#!/bin/bash
echo "🤖 AI PLUS SÜPER BOT: Operasyon Başlıyor..."

cd ~/MasterAgent || exit

# 1. Hatalı yerel derlemeyi çöpe atıp, Kusursuz Bulut Talimatını hazırlıyoruz
mkdir -p .github/workflows
cat > .github/workflows/otonom_build.yml << 'EOW'
name: Kusursuz Bulut Fabrikasi
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Java 17 Kurulumu
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'
      - name: Izinleri Ayarla
        run: chmod +x gradlew
      - name: APK Derle (Otonom)
        run: ./gradlew assembleDebug
      - name: APK Teslimati
        uses: actions/upload-artifact@v3
        with:
          name: MasterAgent_APK
          path: app/build/outputs/apk/debug/*.apk
EOW

# 2. Kodları Buluta Fırlat
echo "🚀 Kodlar GitHub sunucularına fırlatılıyor..."
git add .
git commit -m "Süper Bot ile Otonom Derleme"
git push -u origin master || git push -u origin main

# 3. Otonom Takip (Bekleme Süresi)
echo "⏳ Bulut Fabrikası APK'yı üretiyor. Bu işlem 2-3 dakika sürecek..."
echo "☕ Sudenaz ile sohbetine devam edebilirsin, işlemi ben takip ediyorum."
sleep 15 # GitHub'ın işlemi başlatması için kısa bir süre tanı

# En son çalışan işlemi bul ve Termux'ta canlı izle
RUN_ID=$(gh run list --limit 1 --json databaseId -q ".[0].databaseId")
echo "👁️ İşlem ID: $RUN_ID bulutta takip ediliyor..."
gh run watch $RUN_ID

# 4. İndir ve İndirilenlere Taşı
echo "📥 Üretim Bitti! APK telefonuna çekiliyor..."
rm -rf /sdcard/Download/MasterAgent_AI_Temp
gh run download $RUN_ID -n MasterAgent_APK -D /sdcard/Download/MasterAgent_AI_Temp

# 5. Klasörden çıkarıp ana İndirilenler klasörüne koy
find /sdcard/Download/MasterAgent_AI_Temp -name "*.apk" -exec cp {} /sdcard/Download/MasterAgent_AI.apk \;
rm -rf /sdcard/Download/MasterAgent_AI_Temp

echo "✅ BAŞARILI! APK doğrudan indirilenler klasörüne kaydedildi:"
echo "📂 /sdcard/Download/MasterAgent_AI.apk"
