#!/bin/bash
echo "🤖 MASTER OTONOM KURTARICI: Operasyon Başlıyor..."

# 1. Git Bağlantısını Onar
cd ~/MasterAgent
git init
git remote add origin https://github.com/kcbyk/MasterAgent_AI.git 2>/dev/null || git remote set-url origin https://github.com/kcbyk/MasterAgent_AI.git

# 2. Bulut Talimatını Yenile (Hatasız Versiyon)
mkdir -p .github/workflows
cat > .github/workflows/android.yml << 'EOW'
name: Otonom Build
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Java 17
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'
      - name: Derle
        run: chmod +x gradlew && ./gradlew assembleDebug
      - name: Upload
        uses: actions/upload-artifact@v3
        with:
          name: MasterAgent_APK
          path: app/build/outputs/apk/debug/*.apk
EOW

# 3. Buluta Fırlat
echo "🚀 Kodlar bulut fabrikasına gönderiliyor..."
git add .
git commit -m "Otonom Tamir ve Build"
git push -u origin master -f

# 4. Canlı Takip ve İndirme
echo "⏳ Bulut APK'yı pişiriyor... Yaklaşık 3 dakika sürer."
sleep 10
RUN_ID=$(gh run list --limit 1 --json databaseId -q ".[0].databaseId")
gh run watch $RUN_ID

echo "📥 APK telefonuna indiriliyor..."
gh run download $RUN_ID -n MasterAgent_APK -D /sdcard/Download/Temp_AI
cp /sdcard/Download/Temp_AI/*.apk /sdcard/Download/MasterAgent_AI_Final.apk
rm -rf /sdcard/Download/Temp_AI

echo "✅ TAMAMLANDI! APK şimdi burada: /sdcard/Download/MasterAgent_AI_Final.apk"
