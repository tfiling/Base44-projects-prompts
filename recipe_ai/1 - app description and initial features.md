# Overview
This product is a responsive web application designed to assist inexperienced individuals who enjoy cooking. The goal of the application is to help these users come up with creative and appropriate recipes that match their preferences, dietary restrictions, and available kitchen resources. Recipes are generated and edited using a third-party large language model (LLM) API. The application aims to simplify the process of discovering and customizing recipes through an intuitive interface and intelligent automation.

# Target Audience
The primary audience for this application consists of people who are not professional chefs but enjoy cooking at home. These users may not have extensive experience or knowledge of recipes and cooking techniques but are enthusiastic about trying new dishes. The application is intended to support occasional cooking sessions rather than daily use. The experience is designed to be simple, engaging, and educational, helping users build confidence in their cooking skills.

# Authentication and Access
Users must log in using a Google account via the OAuth 2.0 authentication protocol. Anonymous or guest access will not be supported. After successful login, the application will store user-specific information and preferences to personalize the recipe generation and suggestion experience.

# User Preferences
Upon first login, users will be prompted to enter their cooking preferences. These preferences include, but are not limited to, dietary restrictions such as allergies, cooking style preferences, available kitchen tools, and skill level. Preferences are stored and used as default answers when generating or searching for recipes. During each recipe generation or search session, users will be able to adjust or override these defaults as needed.

# Main User Flows
## 5.1 Finding an Existing Recipe
After logging in, the user may click a button labeled "Let's find a recipe." This initiates a short question-and-answer session where the application uses previously saved preferences as default answers. Based on these responses, the application suggests a recipe from the user's saved recipe library or recipe history.

## 5.2 Generating a New Recipe
Alternatively, the user may choose to generate a completely new recipe by clicking a button labeled "Generate a new recipe." The application will then ask the user a series of questions, including:
- Which ingredients and spices are currently available
- Preferred kitchen or regional cooking style (such as Italian or Thai)
- Any allergies or dietary restrictions
- User's skill level in cooking (mandatory)
- Available kitchen tools (mandatory)
- Type of dish they want to make (starter, main course, dessert)
- Optional preferred preparation and cooking time

These inputs are sent to the LLM, which generates a recipe based on the provided information. The resulting recipe will be presented to the user in a structured format.

## 5.3 Editing a Recipe
After a recipe has been generated, the user can provide free-text feedback such as "make it vegetarian" or "use rice instead of pasta." The application uses this input to regenerate and overwrite the current recipe using the LLM. The previous version of the recipe will not be stored. Version control and history tracking of recipe edits are not part of the initial release but are considered for future development.

## 5.4 Saving and Managing Recipes
All generated recipes are automatically added to the user's personal recipe history. Users can choose to manually save a recipe, in which case it will appear in a dedicated saved recipes library. Users can also manually edit the content of a recipe, including ingredients, steps, and other metadata.

# Recipe Structure
Each recipe presented to the user will include the following components:
- A complete list of ingredients required
- Step-by-step preparation and cooking instructions
- Estimated preparation and cooking time
- Number of servings

Images or visuals will not be included in the initial version of the application.

# Data Management
The application will maintain the following types of data per user:
- User preferences, including allergies, skill level, kitchen tools, and other personal configurations
- A history of all generated recipes, automatically stored
- A library of manually saved recipes that the user explicitly marks for future use

Data will be persistent across sessions and tied to the user's authenticated account.

# LLM Integration
The application architecture will allow the integration of multiple LLM providers via a pluggable API design. The first implementation will include integration with the Claude LLM API provided by Anthropic. The API will be used for both initial recipe generation and subsequent edits based on user feedback.

# Essential Features for First Release
- A responsive web interface that works across devices and screen sizes
- OAuth 2.0 authentication using a Google account
- User preference setup and storage
- Recipe generation based on user inputs
- Recipe editing via free-text feedback using the LLM
- Manual recipe editing interface
- Recipe history and saved recipe management
- Measurement unit conversion features
- Persistent user configuration