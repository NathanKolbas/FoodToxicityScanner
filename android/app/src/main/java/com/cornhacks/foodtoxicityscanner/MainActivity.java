package com.cornhacks.foodtoxicityscanner;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.camera.core.CameraX;
import androidx.camera.core.ImageCapture;
import androidx.camera.core.ImageCaptureConfig;
import androidx.camera.core.Preview;
import androidx.camera.core.PreviewConfig;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.lifecycle.LifecycleOwner;


import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.Matrix;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.util.Rational;
import android.util.Size;
import android.view.Surface;
import android.view.TextureView;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.Toast;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.ml.vision.FirebaseVision;
import com.google.firebase.ml.vision.common.FirebaseVisionImage;
import com.google.firebase.ml.vision.text.FirebaseVisionText;
import com.google.firebase.ml.vision.text.FirebaseVisionTextRecognizer;
import com.theartofdev.edmodo.cropper.CropImage;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    private int REQUEST_CODE_PERMISSIONS = 101;
    private final String[] REQUIRED_PERMISSIONS = new String[]{"android.permission.CAMERA", "android.permission.WRITE_EXTERNAL_STORAGE", "android.permission.READ_EXTERNAL_STORAGE"};
    TextureView textureView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        textureView = findViewById(R.id.view_finder);
        if (allPermissionsGranted()) {
            startCamera();
        } else {
            requestPermissions();
        }
    }

    private void startCamera() {
        CameraX.unbindAll();

        Rational aspectRatio = new Rational (textureView.getWidth(), textureView.getHeight());
        Size screen = new Size(textureView.getWidth(), textureView.getHeight()); //size of the screen

        PreviewConfig pConfig = new PreviewConfig.Builder().setTargetAspectRatio(aspectRatio).setTargetResolution(screen).build();
        Preview preview = new Preview(pConfig);

        preview.setOnPreviewOutputUpdateListener(
                new Preview.OnPreviewOutputUpdateListener() {
                    //to update the surface texture we  have to destroy it first then re-add it
                    @Override
                    public void onUpdated(Preview.PreviewOutput output){
                        ViewGroup parent = (ViewGroup) textureView.getParent();
                        parent.removeView(textureView);
                        parent.addView(textureView, 0);

                        textureView.setSurfaceTexture(output.getSurfaceTexture());
                        updateTransform();
                    }
                });


        ImageCaptureConfig imageCaptureConfig = new ImageCaptureConfig.Builder().setCaptureMode(ImageCapture.CaptureMode.MAX_QUALITY)
                .setTargetRotation(getWindowManager().getDefaultDisplay().getRotation()).build();
        final ImageCapture imgCap = new ImageCapture(imageCaptureConfig);

        findViewById(R.id.imgCapture).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                File file = new File(Environment.getExternalStorageDirectory() + "/Scan.jpeg");
                imgCap.takePicture(file, new ImageCapture.OnImageSavedListener() {
                    @Override
                    public void onImageSaved(@NonNull File file) {
                        // Crop
                        CropImage.activity(Uri.fromFile(file))
                                .start(MainActivity.this);
                    }

                    @Override
                    public void onError(@NonNull ImageCapture.UseCaseError useCaseError, @NonNull String message, @Nullable Throwable cause) {
                        String msg = "Pic capture failed : " + message;
                        Toast.makeText(getBaseContext(), msg, Toast.LENGTH_LONG).show();
                        if(cause != null){
                            cause.printStackTrace();
                        }
                        System.out.println(useCaseError);
                        System.out.println(message);
                        System.out.println(cause);
                    }
                });
            }
        });

        //bind to lifecycle:
        CameraX.bindToLifecycle((LifecycleOwner)this, preview, imgCap);
    }

    private void updateTransform(){
        Matrix mx = new Matrix();
        float w = textureView.getMeasuredWidth();
        float h = textureView.getMeasuredHeight();

        float cX = w / 2f;
        float cY = h / 2f;

        int rotationDgr;
        int rotation = (int)textureView.getRotation();

        switch(rotation){
            case Surface.ROTATION_0:
                rotationDgr = 0;
                break;
            case Surface.ROTATION_90:
                rotationDgr = 90;
                break;
            case Surface.ROTATION_180:
                rotationDgr = 180;
                break;
            case Surface.ROTATION_270:
                rotationDgr = 270;
                break;
            default:
                return;
        }

        mx.postRotate((float)rotationDgr, cX, cY);
        textureView.setTransform(mx);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE) {
            CropImage.ActivityResult result = CropImage.getActivityResult(data);
            if (resultCode == RESULT_OK) {
                Uri resultUri = result.getUri();

                // OCR Detection
                FirebaseVisionImage image;
                try {
                    image = FirebaseVisionImage.fromFilePath(MainActivity.this, resultUri);
                    FirebaseVisionTextRecognizer detector = FirebaseVision.getInstance().getOnDeviceTextRecognizer();
                    Task<FirebaseVisionText> firebaseResult = detector.processImage(image).addOnSuccessListener(new OnSuccessListener<FirebaseVisionText>() {
                        @Override
                        public void onSuccess(FirebaseVisionText firebaseVisionText) {
                            String allText = firebaseVisionText.getText().toUpperCase();

                            String[] ingredients = allText.split(", ");
                            ingredients[0] = ingredients[0].replace("INGREDIENTS: ", "");

                            final List<Ingredient> ingredientsList = new ArrayList<>();
                            for (String ingredient : ingredients) {
                                for (int i = 0; i < ToxicCheck.names.length; i++) {
                                    if (ToxicCheck.names[i].contains(ingredient)) {
                                        ingredientsList.add(new Ingredient(ingredient, ToxicCheck.description[i], ToxicCheck.safteyRating[i]));
                                        break;
                                    }
                                }
                            }

                            final ScrollView scrollView = findViewById(R.id.scrollView);
                            final LinearLayout layout = (LinearLayout) findViewById(R.id.ingredientLayout);
                            scrollView.setVisibility(View.VISIBLE);
                            for (int i = 0; i < ingredientsList.size(); i++) {
                                Button ingredient = new Button(MainActivity.this);
                                ingredient.setText(ingredientsList.get(i).getName());
                                final ToxicCheck.SAFTEY_RATINGS rating = ingredientsList.get(i).getSafteyRatings();
                                switch(rating) {
                                    case SAFE :
                                        ingredient.setTextColor(Color.GREEN);
                                        break;

                                    case CAUTION :
                                        ingredient.setTextColor(Color.parseColor("#FFA500"));
                                        break;

                                    case CUT :
                                        ingredient.setTextColor(Color.YELLOW);
                                        break;

                                    case CPSA :
                                        ingredient.setTextColor(Color.BLUE);
                                        break;

                                    case AVOID :
                                        ingredient.setTextColor(Color.RED);
                                        break;
                                }
                                ingredient.setId(i);

                                layout.addView(ingredient);

                                final String title = ingredientsList.get(i).getName();
                                final String description = ingredientsList.get(i).getDescription();

                                ingredient.setOnClickListener(new View.OnClickListener() {
                                    public void onClick(View view) {
                                        AlertDialog.Builder dialog = new AlertDialog.Builder(MainActivity.this)
                                                .setTitle(title)
                                                .setMessage(description)
                                                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                                                    public void onClick(DialogInterface dialog, int which) {

                                                    }
                                                })
                                                .setIcon(android.R.drawable.ic_dialog_alert);
                                        switch(rating) {
                                            case SAFE :
                                                dialog.setIcon(R.drawable.safebig_0);
                                                break;

                                            case CAUTION :
                                                dialog.setIcon(R.drawable.cautionbig);
                                                break;

                                            case CUT :
                                                dialog.setIcon(R.drawable.cutbig);
                                                break;

                                            case CPSA :
                                                dialog.setIcon(R.drawable.certainbig);
                                                break;

                                            case AVOID :
                                                dialog.setIcon(R.drawable.avoidbig);
                                                break;
                                        }
                                        dialog.show();
                                    }
                                });
                            }
                            Button close = findViewById(R.id.closeButton);
                            close.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    layout.removeAllViews();
                                    scrollView.setVisibility(View.GONE);
                                }
                            });


                        }
                    })
                            .addOnFailureListener(
                                    new OnFailureListener() {
                                        @Override
                                        public void onFailure(@NonNull Exception e) {
                                            // Task failed with an exception
                                            // ...
                                        }
                                    });
                } catch (IOException e) {
                    e.printStackTrace();
                }
            } else if (resultCode == CropImage.CROP_IMAGE_ACTIVITY_RESULT_ERROR_CODE) {
                Exception error = result.getError();
            }
        }
    }

    public void requestPermissions() {
        ActivityCompat.requestPermissions(this, REQUIRED_PERMISSIONS, REQUEST_CODE_PERMISSIONS);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (requestCode == REQUEST_CODE_PERMISSIONS) {
            if (!allPermissionsGranted()) {
                requestPermissions();
            } else {
                startCamera();
            }
        }
    }

    private boolean allPermissionsGranted() {
        boolean allPermissionsGranted = true;
        for(String permission : REQUIRED_PERMISSIONS){
            if (ContextCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED) {
                allPermissionsGranted = false;
            }
        }
        return allPermissionsGranted;
    }
}
