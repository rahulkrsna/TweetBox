# Project 5 - *TweetBox*

**TweetBox** is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: **40** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can sign in using OAuth login flow
- [X] User can view last 20 tweets from their home timeline
- [X] The current signed in user will be persisted across restarts
- [X] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- [X] Retweeting and favoriting should increment the retweet and favorite count.
- [X] Tweet Details Page: User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [X] Profile page:
   - [X] Contains the user header view
   - [X] Contains a section with the users basic stats: # tweets, # following, # followers
- [X] Home Timeline: Tapping on a user image should bring up that user's profile page
- [X] Compose Page: User can compose a new tweet by tapping on a compose button.

The following **optional** features are implemented:

- [X] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [X] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [X] User can pull to refresh.
- [X] When composing, you should have a countdown in the upper right for the tweet limit.
- [X] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [ ] Profile Page
   - [ ] Implement the paging view for the user description.
   - [ ] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
   - [ ] Pulling down the profile page should blur and resize the header image.
- [ ] Account switching
   - [ ] Long press on tab bar to bring up Account view with animation
   - [ ] Tap account to switch to
   - [ ] Include a plus button to Add an Account
   - [ ] Swipe to delete an account

The following **additional** features are implemented:

- [X] Scroll to top of the view on click of the Home Button on navigation bar
- [X] User Profile page

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I would like to discuss how did everyone handle the particular tweet for which retweet or favourite option is selected.
2. I would also like to discuss if anyone has made any network related optimizations.
3. I would like to discuss the way the delegates are done from ViewController to UITableViewCell to handle the tap guesture from the imageView
4. Auto Layouts is one area I am more comfortable now, the time I take to create views has reduced a lot. Initially I took few hours to desing one table cell, but now I am able to design the cell with auto layout in pretty quick time.

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/YeZgZoU.gif' title='TweetBox' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

1. Working on Retweet and Favourite options, I took some time figuring out on how to achieve this. How to get the image updates done and how to maintain the status of current user selection and the count.
2. Autolayout is another area where I had to spend considerable amount of time. I feel I am getting the feel of how to do it. The more I do it..
3. Creating a delegate and using to pass the control back and forth in case of tap on imageview to show the user view
4. Also there are few ocassions, where the task needs to be done, like the retweet operation has to be done from different views but it's the same functionality, Except for the api call  I wasn't able to reuse the code. I wish I had time to think of a better design. Though I have completed the application, placing the similar code at multiple places isn't a thing that I didn't like. From next time I would try and think of a better design. 

## License

    Copyright [2016] [Rahul Krishna Vasantham]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.