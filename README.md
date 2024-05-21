# Recipe Finder

Recipe Finder is a web application that helps users find the most relevant recipes they can prepare with the ingredients they have at home. The application consists of a React frontend and a Rails API backend.

## Table of Contents

- [Project Description](#project-description)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

## Project Description

The Recipe Finder application allows users to input the ingredients they have at home and receive a list of recipes they can make with those ingredients. Users can view recipe details, including ingredients, preparation steps, and cook time. Additionally, users can rate recipes and see average ratings for each recipe.

## Features

- Input ingredients to find matching recipes
- View detailed recipe information
- Rate recipes and view average ratings

## Tech Stack

- **Frontend**: React
- **Backend**: Ruby on Rails API
- **Database**: PostgreSQL
- **Hosting**: Fly.io

## Setup Instructions

### Prerequisites

- Node.js (for the React frontend)
- Ruby and Rails (for the backend)
- PostgreSQL (for the database)
- Docker (for containerization)
- Fly.io CLI (for deployment)

### Project Structure
```text
recipe-finder/
├── backend/
└── frontend/
```

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend

2. Install dependencies:
   ```bash
   bundle install

3. Create and migrate the database:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   
4. Start the Rails server:
   ```bash
   rails server

### Frontend Setup
1. Navigate to the frontend directory:
   ```bash
   cd ../recipe-finder-frontend

2. Install Dependencies
   ```bash
   npm install
   
3. Rename .env_sample to.env and add your backend URL: (or leave it by default to localhost:3000 for Rails API)

4. Start the React development server:
   ```bash
   npm start-frontend
   
5. If you want to run both of them concurrently with one command, you can use the command in script in the `package.json` file.
   ```bash
   npm start

## Usage

1. Navigate to the frontend URL (usually `http://localhost:3001` or public url `https://recipe-finder-fe.fly.dev/`) in your web browser.
2. Enter the ingredients you have at home in the search bar and click "Search".
3. Browse the list of matching recipes and click on a recipe to view details.

### Configuring the Frontend to Connect to the Public Backend

Ensure the frontend is configured to connect to the backend API. You can set this up using environment variables.

1. Create a `.env` file in the `frontend` directory:

   ```plaintext
   REACT_APP_BACKEND_API_URL=https://recipe-finder-be.fly.dev/

   
