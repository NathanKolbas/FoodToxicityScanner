package com.cornhacks.foodtoxicityscanner;

import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

public class IngredientLookup {
    public static String getWebsiteContent(String url) {
        String content = null;
        URLConnection connection = null;
        try {
            connection = new URL(url).openConnection();
            Scanner scanner = new Scanner(connection.getInputStream());
            scanner.useDelimiter("\\Z");
            content = scanner.next();
            scanner.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return content;
    }

    public static String getIngredientDescription(String html, String ingredient) {
        String ingredientHeader = ingredient.toUpperCase();
        // Get the SECOND index of the header (find the index of the header starting AFTER its FIRST index
        int ingredientIndex = html.indexOf(ingredientHeader, html.indexOf(ingredientHeader) + 1);
        int startIndex = html.lastIndexOf("<div", ingredientIndex);
        int endIndex = html.indexOf("</div>", ingredientIndex) + "</div>".length();
        if (startIndex == -1 || endIndex == -1) {
            return null;
        }
        return html.substring(startIndex, endIndex);
    }

    public static List<String> parseIngredients(String ingredientData) {
        ingredientData = ingredientData.replace("\n", " ");
        String[] ingredientArray = ingredientData.split(", ");
        List<String> ingredients = new ArrayList<>(Arrays.asList(ingredientArray));
        return ingredients;
    }

    public static List<Ingredient> createIngredients(List<String> names, String html) {
        List<Ingredient> ingredients = new ArrayList<>();
        for (String candidate : names) {
            String description = getIngredientDescription(html, candidate);
            int index = Arrays.binarySearch(ToxicCheck.names, candidate.toUpperCase());
            ToxicCheck.SAFTEY_RATINGS safetyRating = ToxicCheck.safteyRating[index];
            if (description != null) {
                ingredients.add(new Ingredient(candidate, description, safetyRating));
            }
        }
        return ingredients;
    }

    public static String formatIngredientInfo(List<Ingredient> ingredients) {
        StringBuilder builder = new StringBuilder("module.exports = {\n");
        for (Ingredient ingredient : ingredients) {
            String description = ingredient.getDescription().replace("'", "\\'");
            builder.append("'").append(ingredient.getName()).append(": ").append(description).append("',\n");
        }
        builder.append("};");
        return builder.toString();
    }
}
