import mysql.connector
import networkx as nx

# ginawa ni rose na changes

# Connect to MySQL database
db_connection = mysql.connector.connect(
    host="localhost",
    user="root",  # Replace with your MySQL username
    password="",  # Replace with your MySQL password
    database="social_media"
)

db_cursor = db_connection.cursor()

# Graph for users and friendships
class SocialMediaGraph:
    def __init__(self):
        self.graph = nx.Graph()
        self._initialize_graph()

    def _initialize_graph(self):
        """Initialize graph nodes and edges from MySQL database."""
        try:
            db_cursor.execute("SELECT username FROM users")
            users = db_cursor.fetchall()
            for user in users:
                self.graph.add_node(user[0])

            db_cursor.execute("SELECT user1, user2 FROM friendships")
            friendships = db_cursor.fetchall()
            for user1, user2 in friendships:
                self.graph.add_edge(user1, user2)
        except mysql.connector.Error as err:
            print(f"Error initializing graph: {err}")

    def add_user(self, username, user_data):
        """Add a new user to the system."""
        try:
            db_cursor.execute("SELECT username FROM users WHERE username = %s", (username,))
            if db_cursor.fetchone():
                print("Username already exists.")
                return False

            db_cursor.execute(
                "INSERT INTO users (username, age, location, gender, interests, social_links, password) "
                "VALUES (%s, %s, %s, %s, %s, %s, %s)",
                (username, user_data["age"], user_data["location"], user_data["gender"],
                 ", ".join(user_data["interests"]), user_data["social_links"], user_data["password"])
            )
            db_connection.commit()
            self.graph.add_node(username)
            return True
        except mysql.connector.Error as err:
            print(f"Error adding user: {err}")
            return False

    def update_user(self, username, field, value):
        """Update a user's information."""
        try:
            query = f"UPDATE users SET {field} = %s WHERE username = %s"
            db_cursor.execute(query, (value, username))
            db_connection.commit()
            print(f"{field.capitalize()} updated successfully.")
        except mysql.connector.Error as err:
            print(f"Error updating user: {err}")

    def recommend_friends(self, username):
        """Recommend friends based on shared interests."""
        if username not in self.graph:
            print(f"User {username} is not in the system.")
            return {}

        # Fetch user's interests
        db_cursor.execute("SELECT interests FROM users WHERE username = %s", (username,))
        user_interests = db_cursor.fetchone()
        if not user_interests:
            return {}
        user_interests = set(user_interests[0].split(", "))

        friends = set(self.graph.neighbors(username))
        recommendations = {}

        # Recommend based on shared interests
        db_cursor.execute("SELECT username, interests FROM users")
        all_users = db_cursor.fetchall()
        for user, interests in all_users:
            if user != username and user not in friends:
                shared_interests = user_interests.intersection(interests.split(", "))
                if shared_interests:
                    recommendations[user] = len(shared_interests)

        sorted_recommendations = dict(sorted(recommendations.items(), key=lambda item: item[1], reverse=True))
        return sorted_recommendations

    def send_friend_request(self, from_user, to_user):
        """Send a friend request to another user."""
        db_cursor.execute("SELECT username FROM users WHERE username = %s", (to_user,))
        if not db_cursor.fetchone():
            print(f"User {to_user} does not exist.")
            return
        if from_user == to_user:
            print("You cannot send a friend request to yourself.")
            return

        db_cursor.execute("SELECT * FROM friend_requests WHERE from_user = %s AND to_user = %s", (from_user, to_user))
        if db_cursor.fetchone():
            print(f"Friend request already sent to {to_user}.")
            return

        db_cursor.execute(
            "INSERT INTO friend_requests (from_user, to_user, status) VALUES (%s, %s, 'pending')",
            (from_user, to_user)
        )
        db_connection.commit()
        print(f"{from_user} sent a friend request to {to_user}")

    def get_friend_requests(self, user):
        """Get all friend requests for the logged-in user."""
        db_cursor.execute("SELECT from_user, status FROM friend_requests WHERE to_user = %s", (user,))
        requests = db_cursor.fetchall()
        return [{"from_user": row[0], "status": row[1]} for row in requests]

    def accept_friend_request(self, user, from_user):
        """Accept a friend request from another user."""
        db_cursor.execute("SELECT * FROM friend_requests WHERE from_user = %s AND to_user = %s", (from_user, user))
        if not db_cursor.fetchone():
            print("No friend request found from this user.")
            return

        db_cursor.execute("UPDATE friend_requests SET status = 'accepted' WHERE from_user = %s AND to_user = %s", (from_user, user))
        db_cursor.execute(
            "INSERT INTO friendships (user1, user2, shared_social_link) VALUES (%s, %s, FALSE), (%s, %s, FALSE)",
            (user, from_user, from_user, user)
        )
        db_connection.commit()
        print(f"{user} accepted the friend request from {from_user}")

    def decline_friend_request(self, user, from_user):
        """Decline a friend request from another user."""
        db_cursor.execute("SELECT * FROM friend_requests WHERE from_user = %s AND to_user = %s", (from_user, user))
        if not db_cursor.fetchone():
            print("No friend request found from this user.")
            return

        db_cursor.execute("UPDATE friend_requests SET status = 'rejected' WHERE from_user = %s AND to_user = %s", (from_user, user))
        db_connection.commit()
        print(f"{user} declined the friend request from {from_user}")

    def share_social_link(self, user, to_user):
        """Share the social link with a new friend."""
        share_social = input(f"Do you want to share your social link with {to_user}? (yes/no): ").strip().lower()
        if share_social == "yes":
            db_cursor.execute(
                "UPDATE friendships SET shared_social_link = TRUE WHERE (user1 = %s AND user2 = %s) OR (user1 = %s AND user2 = %s)",
                (user, to_user, to_user, user)
            )
            db_connection.commit()
            print(f"Your social link has been shared with {to_user}.")
        else:
            print("Social link not shared.")


# User account functionalities
def create_account(sm_graph):
    print("\n--- Create Account ---")
    username = input("Create username: ")
    password = input("Create password: ")
    gender = input("Gender (Male/Female): ")
    age = int(input("Age: "))

    # Enforce age restriction (18+ only)
    if age < 18:
        print("You must be at least 18 years old to create an account.")
        return

    location = input("Location: ")

    # Social links are mandatory
    social_links = input("Social links (required): ")

    # Ensure the user enters something for social links
    if not social_links:
        print("Social links are required. Please provide a valid link.")
        return

    print("You must pick 5 interests from the list below:")
    interests = select_interests()
    terms = input("Do you agree to the Terms and Conditions? (yes/no): ").lower()

    if terms != "yes":
        print("You must agree to the Terms and Conditions to create an account.")
        return

    user_data = {
        "age": age,
        "location": location,
        "gender": gender,
        "social_links": social_links,
        "interests": interests,
        "password": password
    }

    if sm_graph.add_user(username, user_data):
        print(f"Account for {username} created successfully.")
    else:
        print("Account creation failed.")


def login():
    print("\n--- Log In ---")
    username = input("Username: ")
    password = input("Password: ")
    try:
        db_cursor.execute("SELECT password FROM users WHERE username = %s", (username,))
        result = db_cursor.fetchone()
        if result and result[0] == password:
            print(f"Welcome back, {username}!")
            return username
        else:
            print("Invalid username or password.")
            return None
    except mysql.connector.Error as err:
        print(f"Error during login: {err}")
        return None


def select_interests():
    """Allow user to pick 5 interests from the predefined list."""
    interest_list = [
        "Art", "Design", "Photography", "Make-up", "Writing", "Dancing", "Singing",
        "Crafts", "Cooking / Baking", "Editing", "Basketball", "Volleyball",
        "Badminton", "Swimming", "Music", "Video Games", "Movie", "Reading", "Social Media"
    ]

    for idx, interest in enumerate(interest_list, 1):
        print(f"{idx}. {interest}")

    selected_interests = []
    while len(selected_interests) < 5:
        try:
            choice = int(input(f"Select interest {len(selected_interests) + 1} (1-{len(interest_list)}): "))
            if 1 <= choice <= len(interest_list) and interest_list[choice - 1] not in selected_interests:
                selected_interests.append(interest_list[choice - 1])
            else:
                print("Invalid choice or interest already selected.")
        except ValueError:
            print("Please enter a valid number.")

    return selected_interests


# Main system
def main():
    sm_graph = SocialMediaGraph()
    logged_in_user = None

    while True:
        if not logged_in_user:
            print("\n--- Welcome to the Social Media Platform ---")
            print("1. Log In")
            print("2. Sign Up")
            print("3. Exit")
        else:
            print("\n--- Main Menu ---")
            print("1. View Friend Recommendations")
            print("2. Friend Menu")
            print("3. Account Settings")
            print("4. Log Out")

        choice = input("Enter your choice: ")

        if choice == "1" and not logged_in_user:
            logged_in_user = login()

        elif choice == "2" and not logged_in_user:
            create_account(sm_graph)

        elif choice == "3" and not logged_in_user:
            print("Goodbye!")
            break

        elif choice == "1" and logged_in_user:
            recommendations = sm_graph.recommend_friends(logged_in_user)
            if recommendations:
                print("\nFriend Recommendations:")
                for user, mutual_count in recommendations.items():
                    print(f"{user} (Shared Interests: {mutual_count})")
            else:
                print("No recommendations available.")

        elif choice == "2" and logged_in_user:
            print("\n--- Friend Menu ---")
            print("1. View Friend Requests")
            print("2. Send Friend Request")
            print("3. Accept Friend Request")
            print("4. Back to Main Menu")

            friend_choice = input("Enter your choice: ")

            if friend_choice == "1":
                requests = sm_graph.get_friend_requests(logged_in_user)
                if not requests:
                    print("No friend requests.")
                else:
                    for req in requests:
                        print(f"{req['from_user']} - Status: {req['status']}")
            
            elif friend_choice == "2":
                to_user = input("Enter the username to send a friend request: ")
                sm_graph.send_friend_request(logged_in_user, to_user)

            elif friend_choice == "3":
                from_user = input("Enter the username to accept a friend request from: ")
                sm_graph.accept_friend_request(logged_in_user, from_user)
                sm_graph.share_social_link(logged_in_user, from_user)

            elif friend_choice == "4":
                continue

        elif choice == "3" and logged_in_user:
            print("\n--- Account Settings ---")
            # Implement account settings functionality here

        elif choice == "4" and logged_in_user:
            logged_in_user = None
            print("Logged out successfully.")

        else:
            print("Invalid choice. Please try again.")


if __name__ == "__main__":
    main()
