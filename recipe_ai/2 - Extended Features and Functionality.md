## Addendum: Extended Features and Functionality

### 1. Saved Recipes Library per User
**Overview**  
- The Saved Recipes Library is private to each user, containing both generated and manually saved recipes.  
- All newly generated recipes automatically appear in the user's **Recipe History**, from which the user can **save** any recipe to their personal Saved Recipes library with a single click.

**Tagging & Organization**  
- Recipes in the Saved Recipes library and Recipe History can be tagged to facilitate search and categorization.  
- When users click an **“Add Tag”** button on a recipe’s page, a text field is displayed. Typing in this field shows existing tags via autocomplete. Users can select an existing tag or create a new one.  
- The Saved Recipes library supports unlimited saved recipes. Pagination or infinite scrolling is used to handle large collections.

**Search & Filter**  
- Users can **search** by free text or filter by tags and other recipe properties (e.g., cooking time, difficulty, etc.).  
- This allows quick discovery of specific recipes within the Saved Recipes library and Recipe History.

---

### 2. Recipe Validation Against Submitted Parameters

**Automatic Validation**  
- Whenever a new recipe is generated or edited by the LLM, the system automatically checks it against the following user-defined constraints:
  1. **Allergies**: The recipe must not include allergens marked by the user.  
  2. **Cooking Time Threshold**: The user can set a default maximum cooking time in Preferences, which can also be overridden on a per-recipe basis.  
  3. **Available Kitchen Tools**: The recipe should avoid requiring tools the user does not have.

**Handling Validation Failures**  
- If a recipe fails any of these validations, the system displays a **warning message** and a **“Try Again”** button.  
- To prevent spamming the backend, the “Try Again” button uses **exponential backoff** (30 seconds → 1 minute → 5 minutes).  
- The application does **not** automatically correct the recipe; the user must choose whether to:
  - **Ignore** the warning and proceed,  
  - **Manually edit** the recipe, or  
  - **Provide free-text feedback** for regeneration (see Editing & Versioning below).

---

### 3. Editing Existing Recipes, Versioning, and Saving Past Versions

**Version Tree Structure**  
- The system maintains an **advanced version tree** for each recipe.  
  - Each generated or manually edited recipe creates a new “child” node linked to its “parent” version.  
  - This version tree is displayed in a **collapsible** UI, allowing the user to expand and view the chronological branch of edits.

**Editing Flows**  
1. **Manual Edit**:  
   - A user clicks “Manual Edit” to open a form where they can directly modify the recipe’s text, steps, or ingredients. Submitting changes creates a new version in the version tree.
2. **AI-Driven Edit (Free-Text Feedback)**:  
   - A user clicks “Provide Feedback,” which opens a modal with a text box.  
   - The user enters feedback such as “Substitute pasta with rice” or “Make it vegetarian.”  
   - Clicking “Edit Recipe Using AI” sends the current recipe version, along with the feedback, to the LLM to generate a revised recipe.  
   - The new recipe automatically becomes a new node (version) in the version tree.

**Version History & Restoration**  
- In the **Recipe History**, only the most recent version of each recipe is displayed. However, a user can open the **history pane** from a specific recipe page to see older versions in a collapsible structure.  
- The user cannot overwrite the “current” version with an older version; instead, they can **save** an older version to their library, which appears as a separate recipe entry in Saved Recipes library.

**No Notifications on Version Creation**  
- The system does not show explicit notifications whenever a new version is created. This occurs silently each time an edit is submitted.

**No Deletion or Limits**  
- There is currently no limit on how many versions can exist.  
- Users cannot delete older versions in this initial release.

---

### 4. Ingredient Substitution Based on Existing Ingredients

**User-Initiated Substitution**  
- The system does **not** proactively prompt for ingredient substitutions.  
- Instead, the user relies on the standard free-text feedback flow (see **Editing Flows** above) to propose ingredient changes or substitutions.

**No Automated Highlighting**  
- The application does **not** highlight unavailable or undesired ingredients in the recipe.  
- No separate wizard or pop-up is provided; all changes are made via free-text feedback to the LLM.

**Ignoring Dietary & Preference Constraints in Substitutions**  
- When the user directly initiates a substitution via feedback, the system does **not** automatically enforce the user’s dietary preferences or constraints. The user must explicitly mention them in their feedback if they wish to maintain those constraints.

---

### 5. Free Text Constraints in User Preferences (Multi-Select)

**Structure & Storage**  
- Users can define any number of free-text constraints (up to **100 characters** each).  
- Each constraint is **standalone** (no nested constraints) and stored as a text string in user preferences.

**Multi-Select & Toggling**  
- In the user’s preference page, these constraints appear as searchable **pill-shaped** items.  
- Users can toggle specific constraints before generating a recipe. Only **toggled** constraints are sent to the LLM.

**Constraint Violations**  
- If a generated recipe violates an active (toggled) constraint, a **warning** is shown to the user.  
- No automatic correction is performed; the user decides whether to ignore the warning, manually edit, or regenerate the recipe.

---

### Additional Technical & Security Considerations

- **Exponential Backoff for Re-Try**  
  - The “Try Again” button for validation failures follows a **30s → 1min → 5min** exponential backoff schedule to reduce server load.
- **Security & Privacy**  
  - Standard data protection applies. No additional constraints or filters (e.g., for profanity) are required for free-text constraints beyond the 100-character limit.
- **Release Plan**  
  - All the above features are to be implemented together without a phased rollout.
