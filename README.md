## Project Overview

### Funnel Analysis at Metrocar

This project aims to analyze the customer funnel of Metrocar, a ride-sharing app (similar to Uber/Lyft), to identify areas for improvement and optimization. You will use SQL to query the data and Tableau for data visualization. 

The stakeholders have asked several business questions that can uncover valuable insights for improving specific areas of the customer funnel. Your task is to conduct a funnel analysis and address the business questions. Explain your reason for your recommendations based on insights retrieved from the data.


### Project Logistics
Most of the project details will be given in the first sprint. From there, each sprint will provided guidance on a different phase of the project.

Sprint 1: Explore the Metrocar Data
The first week will mainly focus on understanding the dataset using SQL. This dataset contains many tables and properties and requires an understanding of the business (ride-sharing) and the company’s funnel.
Sprint 2: Funnel Visualizations and Insights
The second sprint will be focused on analyzing the data and reaching conclusions regarding the given business questions.
Sprint 3: Present the Funnel Results
The third sprint will be mostly reserved for preparing and recording the final submission based on your insights and recommendations.
Sprint 4: Continued Project Work
You can use this week to finalize the project and to record and submit your presentations.

Project Deliverables
Any data analysis project you do will take its final form as a “deliverable” of some sort. A deliverable is something you can point to as the output of your work, like a dashboard or a model. In this case, we have the following deliverables:

Video Presentation: Summarize key findings in slides and record a short walkthrough of the results for Metrocar stakeholders.
Tableau Dashboard: Publish an accurate and dynamic dashboard to allow the Metrocar stakeholders to explore the funnel from multiple perspectives.
Tableau Story: Craft a guided narrative that highlights the user journey, and key funnel insights for the Metrocar team.
SQL File: Document the key queries used in the Tableau Dashboard and Story.

Project Background
Funnel analysis is a method in data analysis used to track and understand the sequential steps or stages that users or customers go through when interacting with a product, service, or website. It's called a "funnel" because the shape of the analysis resembles that of a real-world funnel – wide at the top and narrow at the bottom. However, it could also be easily represented by a bar chart.


Funnel analysis allows businesses and organizations identify where users drop off or convert, helping them to ultimately increase desired outcomes, such as sales, sign-ups, or conversions. It is widely used in e-commerce, marketing, and product development to drive growth and revenue.


🚗 About Metrocar

Metrocar's business model is based on a platform that connects riders with drivers through a mobile application. Metrocar acts as an intermediary between riders and drivers, providing a user-friendly platform to connect them and facilitate the ride-hailing process.


📶 Metrocar’s Funnel

The customer funnel for Metrocar typically includes the following stages:

App Download: A user downloads the Metrocar app from the App Store or Google Play Store.
Signup: The user creates an account in the Metrocar app, including their name, email, phone number, and payment information.
Request Ride: The user opens the app and requests a ride by entering their pickup location, destination, and ride capacity (2 to 6 riders).
Driver Acceptance: A nearby driver receives the ride request and accepts the ride.
Ride: The driver arrives at the pickup location, and the user gets in the car and rides to their destination.
Payment: After the ride, the user is charged automatically through the app, and a receipt is sent to their email.
Review: The user is prompted to rate their driver and leave a review of their ride experience.
Similar to other customer funnels, there will be drop-offs at every stage, which is why funnel analysis can be helpful in identifying areas for improvement and optimization. For example, Metrocar may analyze the percentage of users who download the app but do not complete the registration process, or the percentage of users who request a ride but cancel before the driver arrives.


🔎 Business questions

You will need to analyze the data and make recommendations based on the following business questions:

What steps of the funnel should we research and improve? Are there any specific drop-off points preventing users from completing their first ride?
Metrocar currently supports 3 different platforms: ios, android, and web. To recommend where to focus our marketing budget for the upcoming year, what insights can we make based on the platform?
What age groups perform best at each stage of our funnel? Which age group(s) likely contain our target customers?
Surge pricing is the practice of increasing the price of goods or services when there is the greatest demand for them. If we want to adopt a price-surging strategy, what does the distribution of ride requests look like throughout the day?
What part of our funnel has the lowest conversion rate? What can we do to improve this part of the funnel?

The Dataset
This dataset is inspired by publicly available datasets for Uber/Lyft. The data for this dataset was generated specifically for this project.


### Dataset structure

You can find a description of each table and its columns below.

app_downloads: contains information about app downloads
app_download_key: unique id of an app download
platform: ios, android or web
download_ts: download timestamp
signups: contains information about new user signups
user_id: primary id for a user
session_id: id of app download
signup_ts: signup timestamp
age_range: the age range the user belongs to
ride_requests: contains information about rides
ride_id: primary id for a ride
user_id: foreign key to user (requester)
driver_id: foreign key to driver
request_ts: ride request timestamp
accept_ts: driver accept timestamp
pickup_location: pickup coordinates
destination_location: destination coordinates
pickup_ts: pickup timestamp
dropoff_ts: dropoff timestamp
cancel_ts: ride cancel timestamp (accept, pickup and dropoff timestamps may be null)
transactions: contains information about financial transactions based on completed rides:
ride_id: foreign key to ride
purchase_amount_usd: purchase amount in USD
charge_status: approved, cancelled
transaction_ts: transaction timestamp
reviews: contains information about driver reviews once rides are completed
review_id: primary id of review
ride_id: foreign kegit y to ride
driver_id: foreign key to driver
user_id: foreign key to user (requester)
rating: rating from 0 to 5
free_response: text response given by user/requester


### Links for Story and Dashboard on Tableau for Metrocar

Link to Tableau story: https://public.tableau.com/views/MetrocarFunnelAnalysisJourneyInsightsStory/StorySlides?:language=en-US&publish=yes&:sid=&:display_count=n&:origin=viz_share_link

Link to Tableau dashboard: https://public.tableau.com/views/MetrocarFunnelAnalysisDashboard_17131029770560/Dashboard1?:language=en-US&publish=yes&:sid=&:display_count=n&:origin=viz_share_link

