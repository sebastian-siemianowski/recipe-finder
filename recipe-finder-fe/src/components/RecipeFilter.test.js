import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom';
import axios from 'axios';
import MockAdapter from 'axios-mock-adapter';
import RecipeFilter from './RecipeFilter';

// Constants for repeated values
const PLACEHOLDER_TEXT = /Enter ingredients, separated by commas/i;
const FIND_RECIPES_BUTTON = /Find Recipes/i;
const CLEAR_BUTTON = /Clear/i;
const LOADING_INDICATOR = 'loading-indicator';
const API_URL = process.env.REACT_APP_BACKEND_API_URL;

describe('RecipeFilter Component', () => {
    let mock;

    beforeEach(() => {
        mock = new MockAdapter(axios);
        jest.spyOn(console, 'error').mockImplementation(() => {}); // Suppress console errors
    });

    afterEach(() => {
        mock.restore();
        jest.resetAllMocks();
    });

    const renderComponent = () => render(<RecipeFilter />);

    const inputIngredients = (ingredients) => {
        fireEvent.change(screen.getByPlaceholderText(PLACEHOLDER_TEXT), {
            target: { value: ingredients },
        });
    };

    const clickButton = (buttonName) => {
        fireEvent.click(screen.getByRole('button', { name: buttonName }));
    };

    const setupMockResponse = (status, data) => {
        mock.onGet(`${API_URL}/recipes`).reply(status, data);
    };

    // Test to ensure the initial UI renders correctly
    test('displays the initial state of the RecipeFilter component', () => {
        renderComponent();
        expect(screen.getByPlaceholderText(PLACEHOLDER_TEXT)).toBeInTheDocument();
        expect(screen.getByRole('button', { name: FIND_RECIPES_BUTTON })).toBeInTheDocument();
        expect(screen.getByRole('button', { name: CLEAR_BUTTON })).toBeInTheDocument();
    });

    // Test to verify the input field updates as the user types
    test('updates input field as user types', () => {
        renderComponent();
        const input = screen.getByPlaceholderText(PLACEHOLDER_TEXT);
        fireEvent.change(input, { target: { value: 'tomato, cheese' } });
        expect(input.value).toBe('tomato, cheese');
    });

    // Test to ensure the component fetches and displays recipes upon form submission
    test('fetches and displays recipes when form is submitted', async () => {
        const recipes = [{ id: 1, title: 'Tomato Soup', cook_time: 30, prep_time: 15, ratings: 4.5, image: '' }];
        setupMockResponse(200, { recipes, total_pages: 1, current_page: 1 });

        renderComponent();
        inputIngredients('tomato, cheese');
        clickButton(FIND_RECIPES_BUTTON);

        await waitFor(() => {
            expect(mock.history.get.length).toBe(1);
            expect(screen.getByText('Tomato Soup')).toBeInTheDocument();
        });
    });

    // Test to check if a loading indicator is displayed during the data fetch process
    test('shows a loading indicator while fetching recipes', async () => {
        setupMockResponse(200, { recipes: [], total_pages: 1, current_page: 1 });

        renderComponent();
        inputIngredients('tomato, cheese');
        clickButton(FIND_RECIPES_BUTTON);

        expect(screen.getByTestId(LOADING_INDICATOR)).toBeInTheDocument();
        await waitFor(() => {
            expect(screen.queryByTestId(LOADING_INDICATOR)).not.toBeInTheDocument();
        });
    });

    // Test to verify error handling when the API call fails
    test('logs an error when the API call fails', async () => {
        setupMockResponse(500);

        renderComponent();
        inputIngredients('tomato, cheese');
        clickButton(FIND_RECIPES_BUTTON);

        await waitFor(() => {
            expect(mock.history.get.length).toBe(1);
            expect(console.error).toHaveBeenCalled();
        });
    });

    // Test to ensure the Clear button resets the input field and clears the displayed results
    test('clears input and results when Clear button is clicked', () => {
        renderComponent();
        inputIngredients('tomato, cheese');
        clickButton(CLEAR_BUTTON);

        expect(screen.getByPlaceholderText(PLACEHOLDER_TEXT).value).toBe('');
        expect(screen.queryByText(/Tomato Soup/i)).not.toBeInTheDocument();
    });
});
