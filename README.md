# jom_pick

![jompick](https://github.com/zahir248/jom_pick/assets/90888537/cc27644b-758a-43af-9f34-7760f2ffe7dd)

1. Introduction

The JomPick System is designed to significantly improve item pick up management in university and public use . Its primary purpose is to facilitate the efficient distribution of client's documents, letters, and parcels, as well as managing the proper disposal of unnecessary items. This system will make it easier for clients, including students, staff, and others, to always be aware and receive timely alerts about the availability of their goods awaiting collection.

2. Problem Statement

- Lack of Real-time Visibility: We struggle with providing customers with real-time visibility into the status of their pickups. This lack of transparency leads to customer dissatisfaction and support inquiries.
- Inaccurate Pickup Documentation: We often encounter issues with inaccurate or missing documentation related to pickups, which can result in disputes, billing errors, and operational setbacks.
- Inadequate Reporting and Analytics: We struggle to gather and analyze data related to pickup operations, hindering our ability to make data-driven decisions and improvements.
- Inefficient Pickup Scheduling: We face challenges in efficiently scheduling and managing pickups for various services. The current system relies heavily on manual processes, leading to delays and operational 
  inefficiencies.

3. Objective

- Develop a customer portal or mobile app that provides real-time updates on pickup status, including estimated client arrival times, and confirmation notifications upon successful pickup.
- Implement a digital document management system that allows staff to capture and upload necessary documentation such as signatures and photos during pickups.This system should integrate with the central database 
  to ensure accuracy and accessibility.
- Develop a robust reporting and analytics module that provides insights into key performance indicators (KPIs), such as pickup success rates, turnaround times, and resource utilization. This system should 
  support customizable reports and dashboards for informed decision-making.
- Implement an automated pickup scheduling system that integrates with GPS technology to optimize routes, considers real-time factors like traffic, and allows customers to schedule pickups conveniently through a 
  user-friendly web or mobile application.

4. Target User

- Students and Staff of University: Students and staff may occasionally need pickups for various purposes, including moving equipment or materials. They should have access to the system to request pickups and 
  track their progress.
- Logistics and Operations Team of University: The logistics and operations team at UTeM would be primary users of the system. They would use it to schedule, manage, and optimize pickups of various items within 
  the university, such as mail, supplies, and equipment.
- Facility Management Staff: This group includes personnel responsible for waste collection, maintenance, and fix bug services. They can use the system to efficiently schedule pickups and maintenance tasks.
- Sustainability Advocates: Individuals or groups within the university who are dedicated to sustainability and environmental impact reduction should be able to use the system to ensure that sustainability goals 
  are met for pickups.
- Admin: To take care of the system.
- Public: Public can also use this app if they drop their item at the University's address.


5. Database Used :

MySQL

In our  system, MySQL is employed as the chosen database, and PHP functions as the server-side language responsible for connecting to and managing interactions with this database. MySQL, recognized as a reliable and scalable relational database management system (RDBMS), stores structured data essential for our application. It provides a platform for executing queries, updates, and other operations on the stored data.

PHP, on the other hand, acts as the intermediary between our Flutter application and the MySQL database. Serving as a server-side scripting language, PHP facilitates the execution of server-side logic in response to requests originating from the Flutter app. The interaction begins with configuring PHP to establish a connection to the MySQL database, specifying crucial details such as the database host, username, password, and database name. Extensions like 'mysqli' or 'PDO' are commonly used in PHP for this purpose.

Once the connection is established, PHP scripts are employed to execute SQL queries, covering a spectrum of database operations, including data retrieval, insertion, updating, and deletion. These scripts handle the processing of results obtained from these queries, often formatting the data to be readily consumable by the Flutter app.

In the context of our Flutter application, communication with the server is facilitated through HTTP requests. The Flutter app uses packages like 'http' or 'dio' to send requests to specific endpoints on the PHP server. The PHP server processes these requests, utilizing the PHP scripts to interact with the MySQL database accordingly. Upon completing the requested operations, the server sends back responses to the Flutter app, typically in the form of JSON data. The Flutter app then parses this data to update its user interface or execute further actions based on the received information.


6. Conceptual Database Design : 

![photo_2024-01-26_19-40-44](https://github.com/zahir248/jom_pick/assets/129832790/5b8c8b00-8325-41b3-8477-51e20bb93ba9)


7. Tech Stack Used

- For mobile => Dart (Flutter)

- For web => HTML, CSS, JavaScript, PHP

- Database => MySQL


