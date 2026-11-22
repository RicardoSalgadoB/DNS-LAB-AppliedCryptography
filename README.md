
# DNS Laboratory

Course project for MA2005B. Tec de Monterrey

## Requirements

To run this project, you need:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Git (optional, if you clone the repository)

Docker Desktop includes Docker Engine, Docker CLI, and Docker Compose, so no additional Docker installation is required.

## Installation

### 1. Install Docker Desktop

#### macOS

1. Go to the [official Docker Desktop for Mac download page](https://docs.docker.com/desktop/setup/install/mac-install/).
2. Download the version corresponding to your Mac:
   - **Apple Silicon** (M1, M2, M3, M4, etc.)
   - **Intel** processor
3. Open the downloaded `.dmg` file.
4. Drag Docker into the `Applications` folder.
5. Open Docker Desktop from the `Applications` folder.
6. Accept the terms and wait for Docker to start.

#### Windows

1. Go to the [official Docker Desktop for Windows download page](https://docs.docker.com/desktop/setup/install/windows-install/).
2. Download Docker Desktop for your Windows architecture.
3. Run the downloaded installer.
4. Follow the installation instructions. If prompted, use the **WSL 2** backend (recommended for most users).
5. Restart your computer if requested.
6. Open Docker Desktop from the Start menu.
7. Wait for Docker Desktop to finish starting.

> **Note:** Windows users may need to enable or install WSL 2. Follow the instructions provided by the Docker Desktop installer if this is required.

### 2. Verify the installation

Open a terminal:

- **macOS:** Terminal
- **Windows:** PowerShell, Windows Terminal, or the terminal in VS Code

Run the following commands to verify that Docker is installed and running:

```bash
docker --version
docker compose version
```

If both commands return version information, Docker is ready to use.

## Running the project

### 1. Download the repository

Clone the repository:

```bash
git clone <repository-url>
```

Navigate to the project directory:

```bash
cd <repository-name>
```

Alternatively, download the repository as a ZIP file from GitHub and extract it.

### 2. Start the application

Make sure Docker Desktop is running.

From the project root directory (where the `compose.yaml` or `docker-compose.yml` file is located), execute:

```bash
docker compose up --build
```

This command will:

- Build the required images, if necessary.
- Download the required images and dependencies.
- Create the containers defined in the Docker Compose file.
- Start the services.

The application logs will be displayed in the terminal.

Once the containers are running, access the application using the URL or port specified in the Docker Compose configuration.

### Run in the background

If you want to run the application without keeping the terminal open, use:

```bash
docker compose up --build -d
```

To check the status of the running containers:

```bash
docker compose ps
```

To view the logs:

```bash
docker compose logs
```

To follow the logs in real time:

```bash
docker compose logs -f
```

## Stopping the application

To stop the application, execute:

```bash
docker compose down
```

This stops and removes the containers and networks created by Docker Compose. Persistent data stored in volumes is not removed by default.

## Useful Docker Compose commands

| Command | Description |
|---|---|
| `docker compose up` | Start the application |
| `docker compose up --build` | Build and start the application |
| `docker compose up -d` | Start the application in the background |
| `docker compose ps` | Show running services |
| `docker compose logs` | Display service logs |
| `docker compose logs -f` | Follow logs in real time |
| `docker compose stop` | Stop containers without removing them |
| `docker compose start` | Start previously stopped containers |
| `docker compose down` | Stop and remove containers and networks |
| `docker compose down -v` | Stop and remove containers, networks, and volumes |

> **Warning:** Use `docker compose down -v` carefully, as it also deletes the associated volumes and may permanently remove persisted application data.

## Troubleshooting

- **Docker is not running:** Make sure Docker Desktop is open and has finished starting.
- **Port already in use:** Check whether another application is using the port configured in the Compose file.
- **Container fails to start:** Check the logs using `docker compose logs`.
- **Changes are not reflected:** Try rebuilding the containers using `docker compose up --build`.
- **Command not found:** Verify that Docker Desktop is installed correctly and that the Docker CLI is available in your terminal.

