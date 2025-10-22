# Munchies – Food Delivery App

## Thank You

I just wanted to say a big thank you to the Eidra engineering team for taking the time to review my work.

This assessment was challenging in all the right ways — it pushed me to think carefully and refine details while still having a lot of fun with it.

I really enjoyed the process and appreciate the opportunity to show how I approach building and polishing an app.

Thanks again for the time and consideration!

— Brad

---

## Approach

- **Framework**: SwiftUI
- **Base iOS Version**: 18.5
- **Xcode Version**: 16.4
  - I know I could have used Xcode 26+ but it isn't installed on my machine, so I used what I currently have available.
- **Orientation**: Portrait mode only
- **Architecture**: MVVM with protocol-based dependency injection

---

## Assumptions

### Design Fidelity
I assumed that **Figma was the source of truth** with respect to design, so I did my best to replicate views even without the ability to measure padding/spacing between items precisely.

### Fonts
Figma specifies custom fonts:
- **Poppins** for the horizontal filter items
- **Inter** for the delivery time text on list view cards

I added these fonts to match the design specs. In a production setting, I would typically discuss with designers and present a case for standardizing fonts within the app to reduce bundle size and maintain consistency.

### Missing Filter Tags
There were no specific instructions on how to handle restaurants with missing filter tags, so I simply used an empty string in those cases.

---

## Implementation Notes

### RestaurantListView

**ScrollView Behavior**
- No specifications on whether the entire view should scroll or just the restaurant list
- I chose the better UX: logo and filters remain fixed at the top while only the restaurant list scrolls

**Animation**
- Added a subtle loading animation:
  - Logo animates from top-center to top-left once data loads
  - List content fades in after the logo animation completes
- Not required by spec, but I thought it improved the user experience
- In production, I would discuss any such additions with Product/UX before implementing

### RestaurantCardView

**Shadow Rendering Workaround**
- Figma shows the card background as white @ 40% opacity
- Technical issue: SwiftUI doesn't render shadows very well on semi-transparent views
- Solution: Place an opaque view behind the semi-transparent one and apply the shadow to the opaque layer
- In production, I would discuss with designers about using a solid background color to avoid this engineering workaround

**Vertical Spacing**
- Figma designs show very tight vertical spacing between text elements in the card view
- Implemented as specified, though I thought a little more breathing room would improve readability

### RestaurantDetailView

**Dismiss Button (Chevron)**
- Figma specifies chevron as 10×17 pixels
- Apple HIG recommends minimum tappable area of 44×44 points
- Implemented with 44×44 tappable area while maintaining visual appearance

**RestaurantDetailCard**
- Designed to handle multiple lines in restaurant names (e.g., "Wayne 'Chad Broski' Burgers")
- Text wraps gracefully with proper line limiting

---

## Testing

### Unit Tests
- Unit tests weren't a specific requirement, but I wanted to demonstrate my ability to write comprehensive tests
- Created 23 unit tests covering:
  - ViewModels (success/failure scenarios, state management)
  - Business logic (filter text generation, AND-based filtering)
  - Edge cases and error handling
- These tests are valuable in organizations with limited QA resources or availability

### UI Tests
- Added UI tests to verify proper layout and element positioning
- Tests validate:
  - RestaurantCardView layout and element presence
  - RestaurantDetailCard layout and navigation flow
- Demonstrates ability to write end-to-end UI validation tests

---

## Architecture Decisions

### Dependency Injection
Because I wanted to add unit tests, I implemented **protocol-based dependency injection** for the network layer:

```swift
protocol RestaurantFetching {
    func fetchRestaurants() async throws -> [Restaurant]
}

// ViewModels accept protocols, not concrete types
init(restaurantFetcher: RestaurantFetching = NetworkService())
```

**Benefits**:
- Improves testability (easy to inject mocks)
- Better maintainability and flexibility
- Follows SOLID principles (Dependency Inversion)

**Trade-off**: Adds some complexity

For simpler projects without comprehensive testing requirements, I would use a more straightforward approach:
```swift
private let service = NetworkService()
```

### MVVM Pattern
- **Models**: Restaurant, Filter, RestaurantStatus
- **Views**: RestaurantListView, RestaurantDetailView, RestaurantCardView, etc.
- **ViewModels**: RestaurantViewModel, RestaurantDetailViewModel
- **Services**: NetworkService with protocol abstractions

Clear separation of concerns with Views handling presentation, ViewModels managing state and business logic, and Services handling data fetching.

---

## Project Structure

```
Munchies/
├── Models/              # Data models
├── Views/               # SwiftUI views
├── View Models/         # MVVM ViewModels
├── Services/            # Network layer
├── Resources/           # Fonts, colors, styles
└── MunchiesTests/       # Unit and UI tests
```

---

## Running the Project

1. Open `Munchies.xcodeproj` in Xcode 16.4+
2. Select a simulator running iOS 18.5+
3. Build and run (⌘R)
4. Run tests (⌘U)

---

## Final Thoughts

This project demonstrates:
- ✅ Modern SwiftUI patterns with @Observable
- ✅ MVVM architecture with proper separation of concerns
- ✅ Protocol-oriented programming and dependency injection
- ✅ Swift concurrency (async/await, structured concurrency)
- ✅ Comprehensive unit and UI testing
- ✅ Attention to design detail and user experience
- ✅ Clean, maintainable, production-ready code

Thank you again for the opportunity!
