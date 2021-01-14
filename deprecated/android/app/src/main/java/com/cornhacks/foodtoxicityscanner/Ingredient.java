package com.cornhacks.foodtoxicityscanner;

public class Ingredient {
    private String name;
    private String description;
    private ToxicCheck.SAFTEY_RATINGS safteyRatings;

    public Ingredient(String name, String description, ToxicCheck.SAFTEY_RATINGS safteyRatings) {
        this.name = name;
        this.description = description;
        this.safteyRatings = safteyRatings;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public ToxicCheck.SAFTEY_RATINGS getSafteyRatings() {
        return safteyRatings;
    }
}
