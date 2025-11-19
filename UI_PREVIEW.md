# Help Page UI Upgrade - Visual Preview

## Layout Structure

```
┌─────────────────────────────────────┐
│         GET HELP (Header)           │
│         [Back] [About Us]           │
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐ │
│  │   🔵 Indigo Gradient Card     │ │
│  │                               │ │
│  │      ⭕ Help Icon              │ │
│  │                               │ │
│  │   Welcome to Get Help!        │ │
│  │   Find answers and manage     │ │
│  │   your account                │ │
│  └───────────────────────────────┘ │
│                                     │
│  📘 How to Use                      │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ 🔵 Step 1                     │ │
│  │ [Touch Icon] Click on each    │ │
│  │ tab to see a detailed         │ │
│  │ explanation of the term. →    │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ 🟣 Step 2                     │ │
│  │ [Swipe Icon] Then, swipe to   │ │
│  │ complete a simple task        │ │
│  │ related to it. →              │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ 🟢 Step 3                     │ │
│  │ [Check Icon] Once you finish, │ │
│  │ check the box to track your   │ │
│  │ progress. →                   │ │
│  └───────────────────────────────┘ │
│                                     │
│  ⚙️ Account Settings                │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ 🚪 Logout                     │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ 🗑️ Delete Account             │ │
│  └───────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

## Visual Features

### 1. Header Section
- **Background**: Indigo gradient (indigo-400 to indigo-600)
- **Icon**: Large help center icon in a circular white-transparent container
- **Text**: Bold white title "Welcome to Get Help!"
- **Subtitle**: Lighter white text "Find answers and manage your account"
- **Shadow**: Soft indigo shadow for depth

### 2. Section Titles
- **Icon Container**: Light indigo background with icon
- **Text**: Bold grey text (20px, Cereal font)
- **Icons**: 
  - Help outline for "How to Use"
  - Settings outline for "Account Settings"

### 3. Feature Cards
- **Step 1 (Blue Gradient)**:
  - Touch app icon in rounded container
  - Blue gradient background (blue-400 to blue-600)
  - White text with step label
  - Chevron arrow indicator
  
- **Step 2 (Purple Gradient)**:
  - Swipe icon in rounded container
  - Purple gradient background (purple-400 to purple-600)
  - White text with step label
  - Chevron arrow indicator
  
- **Step 3 (Green Gradient)**:
  - Check circle icon in rounded container
  - Green gradient background (green-400 to green-600)
  - White text with step label
  - Chevron arrow indicator

### 4. Action Buttons
- **Logout Button**:
  - Red accent background
  - Logout icon + text
  - Soft red shadow
  - Rounded corners (12px)
  
- **Delete Account Button**:
  - Dark grey/black background
  - Delete icon + text
  - Soft grey shadow
  - Rounded corners (12px)

### 5. Confirmation Dialog
- **Warning Icon**: Red warning icon in title
- **Rounded Corners**: 16px border radius
- **Styled Buttons**: Cancel (grey) and Delete (red with light background)

## Color Scheme
- **Primary**: Indigo (header, section icons)
- **Steps**: Blue, Purple, Green gradients
- **Actions**: Red (logout), Dark Grey (delete)
- **Background**: Light grey (#F9F9F9)
- **Text**: White (on gradients), Grey-800 (section titles)

## Typography
- **Font Family**: Cereal (Airbnb Cereal)
- **Header Title**: 28px, Weight 900
- **Section Titles**: 20px, Weight 700
- **Card Text**: 16px, Weight 500
- **Button Text**: 18px, Weight Bold

## Interactive Elements
- **Cards**: Tap-able with InkWell ripple effect
- **Buttons**: Elevated with shadows, tap feedback
- **Icons**: Clear visual indicators for each step





