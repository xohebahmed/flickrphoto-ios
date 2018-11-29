# flickrphoto-ios


Feature Scope: The app allows users to enter the pictures of items they want to search and displays them in a collection view restricting to 3 items in a single row. 
There is infinite scrolling till all the items are fetched from server and that happens through pagination.
The images that are fetched are cached using NSCache provided by foundation framework.

Areas of improvement.
1. The images are displayed in a fixed sized cell with a fixed image size which scaled down preserinvg the aspect ratio. So user may see green padding on the boundary. My proposed solution for this will be to show users image of varying heights keeping width fixed and preserving the aspect rario. This would require a major change in design

2. It would be good if we have a way of priorizing downloads of images that lie in the  visible area of screen. 

3. More test cases needs to be addeds.

4. I have not created view model for search view controller as there was not much requirement. If any persistence is required to show list of already searched items and view model will be required to segregate business logic.

5. I have tightly coupled network manager with caching. Those can be segregated.

6. I have not added a co ordinator to manage the navigations here but if requirement extends then that may be necessary.

7. I have not handled no network scenarios explicitly notifying user to check internet connnections.

