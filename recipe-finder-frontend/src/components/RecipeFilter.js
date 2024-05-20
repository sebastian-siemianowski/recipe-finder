import React, { useState } from 'react';
import axios from 'axios';
import { useTransition, animated } from '@react-spring/web';
import { LazyLoadImage } from 'react-lazy-load-image-component';
import ClipLoader from 'react-spinners/ClipLoader';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faSearch, faTimes, faClock, faStar, faUtensils, faChevronLeft, faChevronRight, faStepBackward, faStepForward } from '@fortawesome/free-solid-svg-icons';
import 'react-lazy-load-image-component/src/effects/blur.css';

const RecipeFilter = () => {
    const [ingredients, setIngredients] = useState('');
    const [recipes, setRecipes] = useState([]);
    const [currentPage, setCurrentPage] = useState(1);
    const [totalPages, setTotalPages] = useState(1);
    const [loading, setLoading] = useState(false);
    const [searched, setSearched] = useState(false);

    const handleInputChange = (event) => {
        setIngredients(event.target.value);
    };

    const fetchRecipes = async (page = 1) => {
        setLoading(true);
        try {
            const response = await axios.get(`http://localhost:3000/recipes`, {
                params: {
                    ingredients: ingredients,
                    page: page,
                },
            });
            setRecipes(response.data.recipes);
            setTotalPages(response.data.total_pages);
            setCurrentPage(response.data.current_page);
        } catch (error) {
            console.error('Error fetching recipes:', error);
        }
        setLoading(false);
        setSearched(true);
    };

    const handleSubmit = (event) => {
        event.preventDefault();
        fetchRecipes();
    };

    const handleClear = () => {
        setIngredients('');
        setRecipes([]);
        setCurrentPage(1);
        setTotalPages(1);
        setSearched(false);
    };

    const handlePageChange = (newPage) => {
        fetchRecipes(newPage);
    };

    const transitions = useTransition(recipes, {
        from: { opacity: 0, transform: 'translate3d(0,20px,0)' },
        enter: { opacity: 1, transform: 'translate3d(0,0px,0)' },
        leave: { opacity: 0, transform: 'translate3d(0,20px,0)' },
        keys: (item) => item.id,
    });

    const visiblePages = () => {
        const pages = [];
        const startPage = Math.max(1, currentPage - 2);
        const endPage = Math.min(totalPages, currentPage + 2);
        for (let i = startPage; i <= endPage; i++) {
            pages.push(i);
        }
        return pages;
    };

    return (
        <div className="min-h-screen bg-gradient-to-r from-indigo-200 via-purple-200 to-pink-200 flex flex-col items-center py-10">
            <h1 className="text-5xl font-extrabold text-gray-800 mb-8 drop-shadow-lg">Recipe Finder</h1>
            <form
                onSubmit={handleSubmit}
                className="w-full max-w-2xl bg-white p-8 rounded-xl shadow-2xl"
            >
                <div className="mb-4 relative">
                    <input
                        type="text"
                        placeholder="Enter ingredients, separated by commas"
                        value={ingredients}
                        onChange={handleInputChange}
                        className="w-full p-4 text-lg border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-300 ease-in-out transform hover:shadow-lg"
                    />
                    <FontAwesomeIcon icon={faSearch} className="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400" />
                </div>
                <div className="flex space-x-4">
                    <button
                        type="submit"
                        className="flex-1 bg-indigo-600 text-white py-3 rounded-lg shadow-lg hover:bg-indigo-700 hover:shadow-xl transition duration-300 transform hover:scale-105 text-lg font-semibold flex items-center justify-center space-x-2"
                    >
                        <FontAwesomeIcon icon={faSearch} />
                        <span>Find Recipes</span>
                    </button>
                    <button
                        type="button"
                        onClick={handleClear}
                        className="flex-1 bg-pink-500 text-white py-3 rounded-lg shadow-lg hover:bg-pink-600 hover:shadow-xl transition duration-300 transform hover:scale-105 text-lg font-semibold flex items-center justify-center space-x-2"
                    >
                        <FontAwesomeIcon icon={faTimes} />
                        <span>Clear</span>
                    </button>
                </div>
            </form>
            <div className="mt-10 w-full max-w-4xl">
                {loading ? (
                    <div className="flex justify-center items-center">
                        <ClipLoader size={50} color={"#123abc"} loading={loading} />
                    </div>
                ) : recipes.length > 0 ? (
                    <div>
                        <ul className="grid grid-cols-1 md:grid-cols-2 gap-8">
                            {transitions((style, recipe) => (
                                <animated.li
                                    key={recipe.id}
                                    style={style}
                                    className="bg-white p-6 rounded-xl shadow-lg flex flex-col items-center transform transition duration-300 hover:scale-105 hover:shadow-2xl"
                                >
                                    <h2 className="text-2xl font-bold mb-4 text-gray-800">{recipe.title}</h2>
                                    <div className="flex items-center mb-2 text-gray-700">
                                        <FontAwesomeIcon icon={faClock} className="mr-2" />
                                        <span className="font-medium">Cook Time: {recipe.cook_time} minutes</span>
                                    </div>
                                    <div className="flex items-center mb-2 text-gray-700">
                                        <FontAwesomeIcon icon={faUtensils} className="mr-2" />
                                        <span className="font-medium">Prep Time: {recipe.prep_time} minutes</span>
                                    </div>
                                    <div className="flex items-center mb-2 text-gray-700">
                                        <FontAwesomeIcon icon={faStar} className="mr-2 text-yellow-500" />
                                        <span className="font-medium">Ratings: {recipe.ratings}</span>
                                    </div>
                                    <div className="w-full h-64 mt-4 rounded-lg shadow-sm overflow-hidden bg-gray-200 relative">
                                        <LazyLoadImage
                                            src={recipe.image}
                                            alt={recipe.title}
                                            effect="blur"
                                            className="w-full h-full object-cover transition-opacity duration-500"
                                        />
                                    </div>
                                </animated.li>
                            ))}
                        </ul>
                        <div className="flex justify-center mt-8 space-x-2">
                            <button
                                onClick={() => handlePageChange(1)}
                                disabled={currentPage === 1}
                                className="px-4 py-2 bg-indigo-500 text-white rounded-lg shadow-md hover:bg-indigo-600 hover:shadow-lg transition duration-300 disabled:opacity-50 text-lg font-semibold flex items-center justify-center space-x-2"
                            >
                                <FontAwesomeIcon icon={faStepBackward} />
                                <span>First</span>
                            </button>
                            <button
                                onClick={() => handlePageChange(currentPage - 1)}
                                disabled={currentPage === 1}
                                className="px-4 py-2 bg-indigo-500 text-white rounded-lg shadow-md hover:bg-indigo-600 hover:shadow-lg transition duration-300 disabled:opacity-50 text-lg font-semibold flex items-center justify-center space-x-2"
                            >
                                <FontAwesomeIcon icon={faChevronLeft} />
                                <span>Previous</span>
                            </button>
                            {visiblePages().map((page) => (
                                <button
                                    key={page}
                                    onClick={() => handlePageChange(page)}
                                    className={`px-4 py-2 ${currentPage === page
                                        ? 'bg-indigo-600 text-white'
                                        : 'bg-indigo-500 text-white'
                                    } rounded-lg shadow-md hover:bg-indigo-600 hover:shadow-lg transition duration-300 text-lg font-semibold`}
                                >
                                    {page}
                                </button>
                            ))}
                            <button
                                onClick={() => handlePageChange(currentPage + 1)}
                                disabled={currentPage === totalPages}
                                className="px-4 py-2 bg-indigo-500 text-white rounded-lg shadow-md hover:bg-indigo-600 hover:shadow-lg transition duration-300 disabled:opacity-50 text-lg font-semibold flex items-center justify-center space-x-2"
                            >
                                <FontAwesomeIcon icon={faChevronRight} />
                                <span>Next</span>
                            </button>
                            <button
                                onClick={() => handlePageChange(totalPages)}
                                disabled={currentPage === totalPages}
                                className="px-4 py-2 bg-indigo-500 text-white rounded-lg shadow-md hover:bg-indigo-600 hover:shadow-lg transition duration-300 disabled:opacity-50 text-lg font-semibold flex items-center justify-center space-x-2"
                            >
                                <FontAwesomeIcon icon={faStepForward} />
                                <span>Last</span>
                            </button>
                        </div>
                    </div>
                ) : (
                    <p className="text-gray-600 text-center text-lg">
                        {searched ? "No recipes found" : "Enter ingredients and click 'Find Recipes' to search."}
                    </p>
                )}
            </div>
        </div>
    );
};

export default RecipeFilter;
