import { ExtensionStorage } from "@bacons/apple-targets";
import Slider from "@react-native-community/slider";
import React, { useState } from "react";
import {
  Alert,
  Button,
  SafeAreaView,
  StyleSheet,
  Text,
  View,
} from "react-native";

// Assicurati che questo sia ESATTAMENTE identico a quello in app.json e in Swift
const storage = new ExtensionStorage("group.com.snapcalorie.data");

export default function MainScreen() {
  // Stati per i selettori (impostati su valori iniziali)
  const [calories, setCalories] = useState(1450);
  const [protein, setProtein] = useState(110);
  const [carbs, setCarbs] = useState(130);
  const [fat, setFat] = useState(45);

  const updateWidgetData = () => {
    // 1. Salva i valori scelti con gli slider nell'App Group condiviso
    storage.set("currentCalories", Math.round(calories));
    storage.set("targetCalories", 2200);
    storage.set("protein", Math.round(protein));
    storage.set("carbs", Math.round(carbs));
    storage.set("fat", Math.round(fat));

    // 2. Forza iOS a ricaricare l'interfaccia del widget
    ExtensionStorage.reloadWidget();
    Alert.alert(
      "Widget Aggiornato!",
      "Torna alla Home per vedere i nuovi valori.",
    );
  };

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>Simulatore SnapCalorie</Text>

      {/* Selettore Calorie */}
      <View style={styles.sliderContainer}>
        <Text style={styles.label}>
          Calorie: {Math.round(calories)} / 2200 kcal
        </Text>
        <Slider
          style={styles.slider}
          minimumValue={0}
          maximumValue={2200}
          value={calories}
          onValueChange={setCalories}
          minimumTrackTintColor="#12C871" // Verde SnapCalorie
        />
      </View>

      {/* Selettore Proteine */}
      <View style={styles.sliderContainer}>
        <Text style={styles.label}>
          Proteine: {Math.round(protein)}g / 150g
        </Text>
        <Slider
          style={styles.slider}
          minimumValue={0}
          maximumValue={150}
          value={protein}
          onValueChange={setProtein}
          minimumTrackTintColor="#007AFF" // Blu
        />
      </View>

      {/* Selettore Carboidrati */}
      <View style={styles.sliderContainer}>
        <Text style={styles.label}>
          Carboidrati: {Math.round(carbs)}g / 200g
        </Text>
        <Slider
          style={styles.slider}
          minimumValue={0}
          maximumValue={200}
          value={carbs}
          onValueChange={setCarbs}
          minimumTrackTintColor="#FF9500" // Arancione
        />
      </View>

      {/* Selettore Grassi */}
      <View style={styles.sliderContainer}>
        <Text style={styles.label}>Grassi: {Math.round(fat)}g / 70g</Text>
        <Slider
          style={styles.slider}
          minimumValue={0}
          maximumValue={70}
          value={fat}
          onValueChange={setFat}
          minimumTrackTintColor="#FF3B30" // Rosso
        />
      </View>

      <View style={styles.buttonWrapper}>
        <Button
          title="Aggiorna Widget"
          onPress={updateWidgetData}
          color="#12C871"
        />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f2f2f7",
    padding: 20,
    justifyContent: "center",
  },
  title: {
    fontSize: 24,
    fontWeight: "bold",
    textAlign: "center",
    marginBottom: 30,
  },
  sliderContainer: {
    backgroundColor: "#fff",
    padding: 15,
    borderRadius: 12,
    marginBottom: 15,
  },
  label: { fontSize: 16, fontWeight: "600", marginBottom: 10 },
  slider: { width: "100%", height: 40 },
  buttonWrapper: {
    marginTop: 20,
    backgroundColor: "#fff",
    borderRadius: 12,
    padding: 5,
  },
});
