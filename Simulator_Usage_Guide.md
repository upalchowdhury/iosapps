# QuitIt iOS Simulator Usage Guide

## 🖥️ Finding the App in Simulator

### Step 1: Locate QuitIt App
1. **Open iOS Simulator** (should already be running with iPhone 16)
2. **Find the QuitIt app icon** on the home screen
   - Look for the app icon (should show "QuitIt" or "Quitit")
   - If not visible, swipe left/right to check other home screen pages
   - Or swipe down and search for "QuitIt"

### Step 2: Launch the App
1. **Tap the QuitIt app icon** to launch
2. **First launch** should show the onboarding flow
3. If you've used it before, it goes directly to the dashboard

## 📱 Simulator Controls & Navigation

### Basic Simulator Controls:
- **Click** = Tap on iPhone
- **Click and drag** = Swipe gesture
- **Scroll** = Click and drag up/down
- **Back gesture** = Swipe from left edge of screen

### Keyboard Input:
- **Text fields** = Click to focus, then type on your Mac keyboard
- **Numbers** = Use number keys or on-screen number pad
- **Done/Return** = Press Enter on Mac keyboard

## 🎯 Step-by-Step App Usage

### First Time Setup (Onboarding):

1. **Welcome Screen**
   - You'll see a welcome message
   - **Click "Get Started"** button at bottom

2. **Habit Selection**
   - You'll see 5 habit options with icons
   - **Click on your habit** (e.g., "Nail Biting")
   - Selected habit will be highlighted
   - **Click "Continue"** button at bottom

3. **Notification Permission**
   - System dialog will appear
   - **Click "Allow"** or "Don't Allow"

4. **Paywall Screen**
   - **Click "Start Free Trial"** or **"Continue"**

### Main App Usage:

#### **Dashboard (Home Screen)**
You'll see:
- Current streak number
- Longest streak
- Today's stats
- Two main buttons: **"Log Urge"** and **"Check In"**

#### **Logging an Urge**
1. **Click "Log Urge"** button on dashboard
2. **Select resistance status**:
   - Click **"Yes, I resisted"** (green) OR
   - Click **"No, I gave in"** (red)
3. **Set intensity**: Drag the slider (1-10)
4. **Select triggers**: Click on trigger chips (can select multiple)
5. **Choose location**: Click segments in location picker
6. **Add notes**: Click text fields and type
7. **Click "Save"** to save the entry

#### **Daily Check-In**
1. **Click "Check In"** button on dashboard
2. **Select day status**:
   - Click **"I stayed strong today"** OR
   - Click **"I had a setback"**
3. **Rate mood**: Click on the mood circles (1-5)
4. **Fill journal sections**: Click text fields and type responses
5. **Click "Save"** to save the check-in

#### **Navigation Tabs**
At bottom of screen, click tabs:
- **Dashboard** (home icon) - Main screen
- **Progress** (chart icon) - Progress tracking
- **Insights** (lightbulb icon) - Data analysis  
- **Settings** (gear icon) - App settings

## 🔧 Troubleshooting Simulator Issues

### If App Won't Launch:
```bash
# In Terminal, run:
xcrun simctl launch booted pluralfocus.Quitit
```

### If App Crashes:
```bash
# Reinstall the app:
xcrun simctl uninstall booted pluralfocus.Quitit
xcrun simctl install booted /path/to/Quitit.app
xcrun simctl launch booted pluralfocus.Quitit
```

### If Simulator is Slow:
- **Device > Erase All Content and Settings**
- **Hardware > Restart**

## 📊 Testing Data Persistence

### Verify Data is Saving:
1. **Log an urge** with specific details
2. **Check dashboard** - numbers should update
3. **Force close app**: Cmd+Shift+H twice, swipe up on QuitIt
4. **Reopen app** - data should still be there
5. **Log another urge** - counts should increment

### Expected Behavior:
- **Current Streak** increases when you resist urges
- **Today's Resisted** counts urges you've resisted today
- **Total Resisted** is lifetime count
- **Dashboard refreshes** immediately after logging

## 🎯 Quick Test Scenario

Try this 5-minute test:

1. **Launch app** → Complete onboarding → Select "Nail Biting"
2. **Log first urge** → "Yes, I resisted" → Intensity 5 → Trigger "Stress" → Save
3. **Check dashboard** → Should show Current Streak = 1, Today's Resisted = 1
4. **Log second urge** → "No, I gave in" → Intensity 8 → Save  
5. **Check dashboard** → Should show Current Streak = 0, Today's Resisted = 1
6. **Complete check-in** → "I had a setback" → Mood = 3 → Add journal notes → Save
7. **Force close and reopen** → All data should persist

This tests the core functionality and data persistence!
