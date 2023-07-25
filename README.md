# Project Name: Pointing Poker

## Overview

Pointing Poker is a real-time web application built using Elixir Phoenix and LiveView, designed to facilitate Scrum Planning meetings by providing a collaborative and interactive Pointing Poker tool. Pointing Poker is a widely used technique in Agile software development, where team members estimate the complexity of tasks or user stories during the planning phase.

This project showcases the power and benefits of using Phoenix and LiveView for building real-time applications that can handle concurrent user interactions seamlessly.

## Features

- Real-time updates: The application uses Phoenix LiveView to enable real-time communication and updates among team members during planning sessions.
- Scrum Poker: Facilitates the estimation process by allowing team members to assign point values to user stories or tasks using a modified Fibonacci sequence.
- Instant Feedback: Team members can see each other's estimates in real-time, promoting collaboration and discussion.
- Room-based Planning: The app supports multiple planning rooms, enabling teams to conduct parallel planning sessions.
- Easy-to-use Interface: The user interface is intuitive, making it simple for team members to participate in the estimation process without a steep learning curve.

## Setup and Installation

1. Ensure you have Elixir and Phoenix installed. If not, follow the installation guides for [Elixir](https://elixir-lang.org/install.html) and [Phoenix](https://hexdocs.pm/phoenix/installation.html).
2. Clone the repository: `git clone git@github.com:CarlosIribar/pointing-poker.git`
3. Change into the project directory: `cd pointing-poker`
4. Install dependencies: `mix deps.get`
5. Create and migrate the database: `mix ecto.setup`
6. Start the Phoenix server: `mix phx.server`
7. Visit `http://localhost:4000` in your web browser.

## How to Use

1. Create a new planning room or join an existing one.
2. Once inside the room, team members can view and discuss the user stories or tasks to be estimated.
3. When it's time to estimate, each team member can privately select their estimate using the Pointing Poker sequence.
4. After all team members have made their selections, the estimates will be revealed simultaneously, promoting unbiased estimations.
5. Discuss any significant discrepancies in estimates to reach a consensus.
6. Rinse and repeat for other user stories or tasks.

## Technologies Used

- Elixir - The programming language used for its robustness and performance.
- Phoenix - A web framework for Elixir that provides the foundation for building web applications.
- LiveView - A part of Phoenix framework that enables real-time, server-rendered views with interactive features.

## Contributing

Contributions to Pointing Poker are welcome and encouraged! If you find any issues or have ideas for improvements, please open an issue or submit a pull request.

1. Fork the repository.
2. Create a new branch for your feature or bug fix: `git checkout -b feature/your-feature-name` or `git checkout -b bugfix/your-bug-name`
3. Commit your changes: `git commit -m "Add some feature"`.
4. Push the branch to your fork: `git push origin feature/your-feature-name` or `git push origin bugfix/your-bug-name`.
5. Open a pull request against the main repository.

## License

This project is open-source and available under the [MIT License](LICENSE).

## Acknowledgments

We would like to thank the Elixir, Phoenix, and LiveView communities for their excellent tools and resources that made this project possible.

---

Feel free to modify this README to fit any additional details about your project or any specific instructions you might want to include. Good luck with your Pointing Poker project!
