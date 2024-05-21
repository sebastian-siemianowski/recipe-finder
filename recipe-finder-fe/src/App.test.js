import React from 'react';
import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom';
import App from './App';

/**
 * Test to ensure the Recipe Finder header renders correctly.
 * This verifies that the main heading of the application is present in the document.
 */
test('renders the Recipe Finder header', () => {
  render(<App />);
  const headerElement = screen.getByText(/Recipe Finder/i);
  expect(headerElement).toBeInTheDocument();
});
