class ChatBotKnowledgeBase {
  // Knowledge base with all help information
  final Map<String, String> _knowledgeBase = {
    // Welcome and greeting
    'greeting': "Hello! I'm here to help you with Track2College. What would you like to know?",
    'hello': "Hi there! How can I assist you today?",
    'hi': "Hello! What can I help you with?",
    
    // How to use - general
    'how to use': """Here's how to use Track2College:

**Step 1: Click on each tab**
Navigate through different tabs in the app to explore various terms and concepts related to college preparation. Each tab contains specific information that will help you understand important terminology used in the college application process.

**Step 2: Complete tasks**
After reading the explanation, you'll find a related task or activity to complete. Swipe left or right on the task card to mark it as complete or to access task details.

**Step 3: Track your progress**
After completing a task, check the box next to it to mark it as done. Your progress is automatically saved, so you can track what you've accomplished.

Would you like more details on any specific step?""",

    // Step 1 details
    'step 1': """**Step 1: Click on each tab to see a detailed explanation of the term**

Navigate through different tabs in the app to explore various terms and concepts related to college preparation. Each tab contains specific information that will help you understand important terminology used in the college application process.

Take your time to read through the explanations - they are designed to make complex concepts easy to understand. You can click on multiple tabs to compare different terms and concepts side by side.

Is there a specific term or concept you'd like to learn more about?""",

    'click tab': """To see detailed explanations, simply click on any tab in the app. Each tab contains information about specific terms and concepts related to college preparation.""",

    'explanation': """Each tab in the app provides detailed explanations of important college-related terms and concepts. Click on any tab to read through the information and learn more about the terminology used in the college application process.""",

    // Step 2 details
    'step 2': """**Step 2: Then, swipe to complete a simple task related to it**

After reading the explanation, you'll find a related task or activity to complete. Swipe left or right on the task card to mark it as complete or to access task details.

Tasks are designed to help you actively engage with the concepts you just learned. Completing tasks helps reinforce your understanding and prepares you for your college journey. You can revisit tasks anytime to review or update your progress.

Need help with a specific task?""",

    'swipe': """To complete tasks, swipe left or right on the task card. This will allow you to mark tasks as complete or access task details.""",

    'complete task': """After reading an explanation, you'll see a related task. Swipe on the task card to mark it as complete or view more details. Tasks help you actively engage with what you've learned.""",

    // Step 3 details
    'step 3': """**Step 3: Once you finish, check the box to track your progress**

After completing a task, check the box next to it to mark it as done. Your progress is automatically saved, so you can track what you've accomplished.

The checked boxes help you visualize your journey and see how much you've completed. You can view your overall progress at any time to stay motivated and organized. You can also uncheck a box if you need to revisit a task or update your work.

Remember: Each checked box represents a step closer to your college goals!""",

    'check box': """To track your progress, simply check the box next to any completed task. Your progress is automatically saved, and you can see how much you've accomplished at any time.""",

    'track progress': """Your progress is automatically saved when you check boxes next to completed tasks. You can view your overall progress anytime to stay motivated and see how much you've accomplished.""",

    // Account settings
    'account': """To manage your account settings, tap the menu icon (three dots) in the top right corner of the chat screen. From there you can:

• **Logout**: Sign out of your account
• **Delete Account**: Permanently delete your account and all associated data

Your progress will be saved when you logout, and you can log back in anytime!""",

    'account settings': """To access account settings, tap the menu icon (⋮) in the top right corner of this screen. You'll find options for:

• **Logout**: Sign out and return to the login screen
• **Delete Account**: Permanently remove your account (this cannot be undone)

Look for the three dots icon in the top right corner!""",

    // Logout
    'logout': """To log out, tap the menu icon (three dots) in the top right corner of this screen, then select "Logout" from the dropdown menu.

You'll be signed out and returned to the login screen. Don't worry - your progress will be saved and you can log back in anytime!""",

    'sign out': """To sign out, tap the menu icon (⋮) in the top right corner and select "Logout". Your progress will be saved, and you can log back in anytime.""",

    // Delete account
    'delete account': """To delete your account, tap the menu icon (three dots) in the top right corner of this screen, then select "Delete Account" from the dropdown menu.

⚠️ **Warning**: Deleting your account will permanently remove:
• All your task progress
• All uploaded documents and resumes
• All saved information
• Your account credentials

This action cannot be undone, so please think carefully before proceeding!""",

    'remove account': """To remove your account, tap the menu icon (⋮) in the top right corner and select "Delete Account". Please note: This action permanently deletes all your data and cannot be undone.""",

    // General help
    'help': """I'm here to help! You can ask me about:

• **How to use the app** - Step-by-step guide
• **Step 1, 2, or 3** - Detailed information about each step
• **General questions** - About using Track2College

💡 **Tip**: For account settings like logout or delete account, tap the menu icon (⋮) in the top right corner!

What would you like to know?""",

    'what can you do': """I can help you with:

📱 **App Usage**
   - How to use Track2College
   - Step-by-step instructions
   - Navigating tabs and tasks

❓ **General Help**
   - Understanding features
   - Troubleshooting
   - Getting started

💡 **Account Settings**: Tap the menu icon (⋮) in the top right corner to access logout or delete account options.

Just ask me anything about Track2College!""",

    // Default/fallback response
    'default': """I'm not sure I understood that. Could you try rephrasing your question?

Here are some things I can help with:
• How to use the app (try asking "how to use")
• Step-by-step guides (try asking "step 1", "step 2", or "step 3")
• Account settings (try asking "logout" or "delete account")
• General help

What would you like to know?""",
  };

  String getResponse(String userMessage) {
    // Normalize the message
    String normalized = userMessage.toLowerCase().trim();
    
    // Remove common punctuation
    normalized = normalized.replaceAll(RegExp(r'[^\w\s]'), ' ');
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');
    
    // Check for exact matches first
    if (_knowledgeBase.containsKey(normalized)) {
      return _knowledgeBase[normalized]!;
    }
    
    // Check for keyword matches
    List<String> keywords = normalized.split(' ');
    
    // Priority matching - more specific matches first
    if (_containsKeywords(normalized, ['delete', 'account', 'remove'])) {
      return _knowledgeBase['delete account']!;
    }
    
    if (_containsKeywords(normalized, ['logout', 'sign out', 'log out'])) {
      return _knowledgeBase['logout']!;
    }
    
    if (_containsKeywords(normalized, ['step 1', 'first step', 'step one'])) {
      return _knowledgeBase['step 1']!;
    }
    
    if (_containsKeywords(normalized, ['step 2', 'second step', 'step two'])) {
      return _knowledgeBase['step 2']!;
    }
    
    if (_containsKeywords(normalized, ['step 3', 'third step', 'step three'])) {
      return _knowledgeBase['step 3']!;
    }
    
    if (_containsKeywords(normalized, ['how to use', 'how do i use', 'how does it work'])) {
      return _knowledgeBase['how to use']!;
    }
    
    if (_containsKeywords(normalized, ['click', 'tab', 'explanation'])) {
      return _knowledgeBase['click tab']!;
    }
    
    if (_containsKeywords(normalized, ['swipe', 'complete task', 'finish task'])) {
      return _knowledgeBase['swipe']!;
    }
    
    if (_containsKeywords(normalized, ['check box', 'track progress', 'mark complete'])) {
      return _knowledgeBase['check box']!;
    }
    
    if (_containsKeywords(normalized, ['account', 'settings'])) {
      return _knowledgeBase['account settings']!;
    }
    
    if (_containsKeywords(normalized, ['hello', 'hi', 'hey'])) {
      return _knowledgeBase['hello']!;
    }
    
    if (_containsKeywords(normalized, ['help', 'what can you do', 'what do you do'])) {
      return _knowledgeBase['help']!;
    }
    
    // Default response
    return _knowledgeBase['default']!;
  }

  bool _containsKeywords(String text, List<String> keywords) {
    for (String keyword in keywords) {
      if (text.contains(keyword.toLowerCase())) {
        return true;
      }
    }
    return false;
  }
}


