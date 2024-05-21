# Recipe Finder

Recipe Finder is a sophisticated web application prototype designed to assist users in discovering recipes they can prepare with ingredients available at home. This application comprises a React frontend and a Rails API backend, seamlessly integrated to provide a smooth user experience.

## Table of Contents

- [Project Description](#project-description)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)

## Project Description

Recipe Finder enables users to input ingredients they have at home and receive a curated list of recipes they can make. Users can view a list of recipes that match their ingredients.

## Features

- **Ingredient-Based Search**: Enter available ingredients to find matching recipes.
- **Recipe List**: View a list of recipes based on the ingredients provided.

## Tech Stack

- **Frontend**: React
- **Backend**: Ruby on Rails API
- **Database**: PostgreSQL
- **Hosting**: Fly.io

## Setup Instructions

### Prerequisites

Ensure the following are installed on your system:

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

1. Navigate to the frontend URL (usually http://localhost:3001 or public URL https://recipe-finder-fe.fly.dev/) in your web browser.
2. Search for recipes: Enter the ingredients you have at home in the search bar and click "Find Recipes".
3. Browse the list of matching recipes: The application will display a list of recipes based on the provided ingredients.

### Configuring the Frontend to Connect to the Public Backend

Ensure the frontend is configured to connect to the backend API. You can set this up using environment variables.

1. Create a `.env` file in the `frontend` directory:

   ```plaintext
   REACT_APP_BACKEND_API_URL=https://recipe-finder-be.fly.dev/
   ```