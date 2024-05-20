import React, { useState } from 'react';
import axios from 'axios';

const RecipeFilter = () => {
    const [ingredients, setIngredients] = useState('');
    const [recipes, setRecipes] = useState([]);

    const handleInputChange = (event) => {
        setIngredients(event.target.value);
    };

    const handleSubmit = async (event) => {
        event.preventDefault();
        try {
            const response = await axios.get(
                `http://localhost:3000/recipes`,
                {
                    params: {
                        ingredients: ingredients,
                    },
                }
            );
            setRecipes(response.data);
        } catch (error) {
            console.error('Error fetching recipes:', error);
        }
    };

    return (
        <div>
            <h1>Recipe Finder</h1>
            <form onSubmit={handleSubmit}>
                <input
                    type="text"
                    placeholder="Enter ingredients, separated by commas"
                    value={ingredients}
                    onChange={handleInputChange}
                />
                <button type="submit">Find Recipes</button>
            </form>
            <div>
                {recipes.length > 0 ? (
                    <ul>
                        {recipes.map((recipe) => (
                            <li key={recipe.id}>
                                <h2>{recipe.title}</h2>
                                <p>Cook Time: {recipe.cook_time} minutes</p>
                                <p>Prep Time: {recipe.prep_time} minutes</p>
                                <p>Ratings: {recipe.ratings}</p>
                                <img src={recipe.image} alt={recipe.title} />
                            </li>
                        ))}
                    </ul>
                ) : (
                    <p>No recipes found</p>
                )}
            </div>
        </div>
    );
};

export default RecipeFilter;
