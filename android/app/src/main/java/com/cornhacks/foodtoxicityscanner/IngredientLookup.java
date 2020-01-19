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

    public static String getIngredientInfo(String html, String ingredient) {
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

    public static List<String> getAllIngredientInfo(List<String> ingredients, String html) {
        List<String> allIngredientInfo = new ArrayList<>();
        for (String candidate : ingredients) {
            String ingredientInfo = getIngredientInfo(html, candidate);
            if (ingredientInfo != null) {
                allIngredientInfo.add(ingredientInfo);
            }
        }
        return allIngredientInfo;
    }
}
