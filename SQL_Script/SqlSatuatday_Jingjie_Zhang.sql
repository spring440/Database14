/*
	Jingjie Zhang 106671199
*/
/*
DROP DATABASE SQLSatuarday
CREATE DATABASE SQLSatuarday
*/

USE s17guest14



CREATE TABLE Venue
(
	venueNumber INT NOT NULL IDENTITY, 
	city VARCHAR(75) NOT NULL,
	venueState VARCHAR(50),
	country VARCHAR(100),
	venueAddress VARCHAR(255) NOT NULL,
	venueName VARCHAR(100) NOT NULL,
	zipcode VARCHAR(30),
	timeZone VARCHAR(50),
	CONSTRAINT PKUnxVenue PRIMARY KEY CLUSTERED(venueNumber)
)

/* Name all CONSTRAINT and INDEX instead of default name */
CREATE TABLE SqlEvent
(
	eventNumber INT  NOT NULL, 
	eventDate DATE NOT NULL, 
	venueNumber INT NOT NULL, 
	maxRegistration INT, 
	city VARCHAR(75) NOT NULL, 
	region VARCHAR(100) NOT NULL,
	CONSTRAINT PKUnxEventNumber PRIMARY KEY CLUSTERED (eventNumber),
	CONSTRAINT FKSqlEventVenueNumber FOREIGN KEY (venueNumber) REFERENCES Venue(venueNumber),
)
CREATE NONCLUSTERED INDEX IdxSqlEventVenueNumber ON SqlEvent(venueNumber ASC)

CREATE TABLE Organizer
(
	organizerNumber INT NOT NULL IDENTITY, 
	personNumber INT NOT NULL,
	requestOrOrganizedBefore VARCHAR(5) CONSTRAINT consRequestBefore CHECK(requestOrOrganizedBefore IN ('true','false','TRUE','FALSE')),
	CONSTRAINT PKUnxOrganizerNumber PRIMARY KEY CLUSTERED (organizerNumber)
)

/* link table */
CREATE TABLE EventHasOrganizer
(
	eventNumber INT NOT NULL, 
	organizerNumber INT NOT NULL,
	CONSTRAINT PKUnxEventHasOrganizer PRIMARY KEY CLUSTERED(eventNumber,organizerNumber),
	CONSTRAINT FKEventHasOrganizerEventNumber FOREIGN KEY (eventNumber) REFERENCES SqlEvent(eventNumber),
	CONSTRAINT FKEventHasOrganizerOrganizerNumber FOREIGN KEY (organizerNumber) REFERENCES Organizer(organizerNumber)
)
CREATE NONCLUSTERED INDEX IdxEventHasOrganizerEventNumber ON EventHasOrganizer(eventNumber ASC)
CREATE NONCLUSTERED INDEX IdxEventHasOrganizerOrganizerNumber ON EventHasOrganizer(organizerNumber ASC)

/* Presentation and session are the same thing here */
CREATE TABLE Presentation
(
	sessionNumber INT NOT NULL IDENTITY,
	title VARCHAR(125) NOT NULL,
	topic VARCHAR(125) NOT NULL,
	presentationDescription TEXT  NOT NULL,
	/* duration in minuts */
	duration INT,
	levelOfComplexity VARCHAR(15),
	readiness VARCHAR(15) NOT NULL CONSTRAINT consReadiness CHECK(readiness IN ('Beginner','Intermediate','Advanced')),
	CONSTRAINT PKUnxSessionNumber PRIMARY KEY CLUSTERED(sessionNumber),
)


/*
 I heard professor said we can make Person table just have an artificial primary key and first name 
 and last name. 
 The address,email, state, city, ziocode can be the column of Attendee table.
 But I still think I should put these detial information in Person table. Because these are common
 information for all people. Presenter will have these information as a Person.
 But I will make the detial information nullable so we can insert presenter into people table
*/
CREATE TABLE Person
(
	personNumber INT NOT NULL IDENTITY,
	firstName VARCHAR(75) NOT NULL,
	lastName VARCHAR(75) NOT NULL,
	emailAddress VARCHAR(255),
	address1 VARCHAR(100),
	address2 VARCHAR(100),
	city VARCHAR(75),
	personState VARCHAR(50),
	country VARCHAR(100),
	zipcode VARCHAR(30),
	phoneNumer VARCHAR(30),
	CONSTRAINT PKUnxPersonNumber PRIMARY KEY CLUSTERED(personNumber)
)


CREATE TABLE Presenter
(
	presenterNumber INT NOT NULL IDENTITY,
	personNumber INT NOT NULL,
	CONSTRAINT PKUnxPresenterNumber PRIMARY KEY CLUSTERED(presenterNumber),
	CONSTRAINT FKPresenterPersonNumber FOREIGN KEY (personNumber) REFERENCES Person(personNumber)
)
CREATE NONCLUSTERED INDEX IdxPresenterPersonNumber ON Presenter(personNumber ASC)


CREATE TABLE Sponsor
(
	sponsorNumber INT NOT NULL IDENTITY, 
	sponsorName VARCHAR(50) NOT NULL, 
	sponsorShipType VARCHAR(30) NOT NULL CONSTRAINT consSponsorShipType CHECK(sponsorShipType IN ('Gold Sponsor','Silver Sponsor','Bronze Sponsor','Platinum Sponsor')),
	serviceDescription TEXT,
	tableNumber INT CONSTRAINT consTableNumber CHECK( tableNumber>=1 and tableNumber<=10 ),
	CONSTRAINT PKUnxSponsorNumber PRIMARY KEY CLUSTERED(sponsorNumber)
)

/* link table */
CREATE TABLE OrganizerKeepTrackOfSession
(
	organizerNumber INT NOT NULL,
	sessionNumber INT NOT NULL,
	CONSTRAINT PKUnxOrganizerKeepTrackOfSession PRIMARY KEY CLUSTERED(organizerNumber,sessionNumber),
	CONSTRAINT FKOrganizerKeepTrackOfSessionOrganizerNumber FOREIGN KEY (organizerNumber) REFERENCES Organizer(organizerNumber),
	CONSTRAINT FKOrganizerKeepTrackOfSessionSessionNumber FOREIGN KEY (sessionNumber) REFERENCES Presentation(sessionNumber)
)
CREATE NONCLUSTERED INDEX IdxOrganizerKeepTrackOfSessionOrganizerNumber ON OrganizerKeepTrackOfSession(organizerNumber ASC)
CREATE NONCLUSTERED INDEX IdxOrganizerKeepTrackOfSessionSessionNumber ON OrganizerKeepTrackOfSession(sessionNumber ASC)


/* link table */
CREATE TABLE OrganizerSolicitSponsor
(
	organizerNumber INT NOT NULL,
	sponsorNumber INT NOT NULL,
	CONSTRAINT PKUnxOrganizerSolicitSponsor PRIMARY KEY CLUSTERED(organizerNumber,sponsorNumber),
	CONSTRAINT FKOrganizerSolicitSponsorOrganizerNumber FOREIGN KEY (organizerNumber) REFERENCES Organizer(organizerNumber),
	CONSTRAINT FKOrganizerSolicitSponsorSponsorNumber FOREIGN KEY (sponsorNumber) REFERENCES Sponsor(sponsorNumber)
)
CREATE NONCLUSTERED INDEX IdxOrganizerSolicitSponsorOrganizerNumber ON OrganizerSolicitSponsor(organizerNumber ASC)
CREATE NONCLUSTERED INDEX IdxOrganizerSolicitSponsorSponsorNumber ON OrganizerSolicitSponsor(sponsorNumber ASC)


/* link table */
CREATE TABLE PresenterPresentSession
(
	presenterNumber INT NOT NULL,
	sessionNumber INT NOT NULL,
	CONSTRAINT PKUnxPresenterPresentSession PRIMARY KEY CLUSTERED(presenterNumber,sessionNumber),
	CONSTRAINT FKPresenterPresentSessionPresenterNumber FOREIGN KEY (presenterNumber) REFERENCES Presenter(presenterNumber),
	CONSTRAINT FKPresenterPresentSessionSessionNumber FOREIGN KEY (sessionNumber) REFERENCES Presentation(sessionNumber)
)
CREATE NONCLUSTERED INDEX IdxPresenterPresentSessionPresenterNumber ON PresenterPresentSession(presenterNumber ASC)
CREATE NONCLUSTERED INDEX IdxPresenterPresentSessionSessionNumber ON PresenterPresentSession(sessionNumber ASC)



/* link table */
CREATE TABLE EventHasSponsor
(
	eventNumber INT NOT NULL,
	sponsorNumber INT NOT NULL,
	CONSTRAINT PKUnxEventHasSponsor PRIMARY KEY CLUSTERED(eventNumber,sponsorNumber),
	CONSTRAINT FKEventHasSponsorEventNumber FOREIGN KEY (eventNumber) REFERENCES SqlEvent(eventNumber),
	CONSTRAINT FKEventHasSponsorSponsorNumber FOREIGN KEY (sponsorNumber) REFERENCES Sponsor(sponsorNumber)
)
CREATE NONCLUSTERED INDEX IdxEventHasSponsorEventNumber ON EventHasSponsor(eventNumber ASC)
CREATE NONCLUSTERED INDEX IdxEventHasSponsorSponsorNumber ON EventHasSponsor(sponsorNumber ASC)



CREATE TABLE Gift
(
	giftNumber INT NOT NULL IDENTITY, 
	sponsorNumber INT NOT NULL, 
	giftName VARCHAR(30) NOT NULL,
	giftDescription TEXT,
	CONSTRAINT PKUnxGift PRIMARY KEY CLUSTERED(giftNumber),
	CONSTRAINT FKGiftSponsorNumber FOREIGN KEY (sponsorNumber) REFERENCES Sponsor(sponsorNumber)
)
CREATE NONCLUSTERED INDEX IdxGiftSponsorNumber ON Gift(sponsorNumber ASC)



/* link table */
CREATE TABLE Raffle
(
	eventNumber INT NOT NULL,
	giftNumber  INT NOT NULL,
	CONSTRAINT PKUnxRaffle PRIMARY KEY CLUSTERED(eventNumber,giftNumber),
	CONSTRAINT FKRaffleEventNumber FOREIGN KEY (eventNumber) REFERENCES SqlEvent(eventNumber),
	CONSTRAINT FKRaffleGiftNumber FOREIGN KEY (giftNumber) REFERENCES Gift(giftNumber)
)
CREATE NONCLUSTERED INDEX IdxRaffleEventNumber ON Raffle(eventNumber ASC)
CREATE NONCLUSTERED INDEX IdxRaffleGiftNumber ON Raffle(giftNumber ASC)



CREATE TABLE Attendee
(
	attendeeNumber INT NOT NULL IDENTITY,
	personNumber INT NOT NULL,
	eventNumber INT,
	CONSTRAINT PKUnxAttendee PRIMARY KEY CLUSTERED(attendeeNumber),
	CONSTRAINT FKAttendeePersonNumber FOREIGN KEY (personNumber) REFERENCES Person(personNumber),
	CONSTRAINT FKAttendeeEventNumber FOREIGN KEY (eventNumber) REFERENCES SqlEvent(eventNumber)
)
CREATE NONCLUSTERED INDEX IdxAttendeePersonNumber ON Attendee(personNumber ASC)
CREATE NONCLUSTERED INDEX IdxAttendeeEventNumber ON Attendee(eventNumber ASC)


CREATE TABLE Volunteer
(
	volunteerNumber INT NOT NULL IDENTITY,
	personNumber INT NOT NULL,
	firstSQLSaturday VARCHAR(5) CONSTRAINT consFirstSQLSaturday CHECK(firstSQLSaturday IN ('true','false','TRUE','FALSE')),
	lunchOption VARCHAR(100)
	CONSTRAINT PKUnxVolunteer PRIMARY KEY CLUSTERED(volunteerNumber),
	CONSTRAINT FKVolunteerPersonNumber FOREIGN KEY (personNumber) REFERENCES Person(personNumber)
)
CREATE NONCLUSTERED INDEX IdxVolunteerPersonNumber ON Volunteer(personNumber ASC)


/* link table */
CREATE TABLE EventHasVolunteer
(
	eventNumber INT NOT NULL,
	volunteerNumber  INT NOT NULL,
	CONSTRAINT PKUnxEventHasVolunteer PRIMARY KEY CLUSTERED(eventNumber,volunteerNumber),
	CONSTRAINT FKEventHasVolunteerEventNumber FOREIGN KEY (eventNumber) REFERENCES SqlEvent(eventNumber),
	CONSTRAINT FKEventHasVolunteerVolunteerNumber FOREIGN KEY (volunteerNumber) REFERENCES Volunteer(volunteerNumber)
)
CREATE NONCLUSTERED INDEX IdxEventHasVolunteerEventNumber ON EventHasVolunteer(eventNumber ASC)
CREATE NONCLUSTERED INDEX IdxEventHasVolunteerVolunteerNumber ON EventHasVolunteer(volunteerNumber ASC)



CREATE TABLE Room
(
	roomNumber INT NOT NULL IDENTITY, 
	venueNumber INT NOT NULL,
	capacity INT NOT NULL,
	roomName VARCHAR(50),
	CONSTRAINT PKUnxRoom PRIMARY KEY CLUSTERED(roomNumber),
	CONSTRAINT FKRoomVenueNumber FOREIGN KEY (venueNumber) REFERENCES Venue(venueNumber)
)
CREATE NONCLUSTERED INDEX IdxRoomVenueNumber ON Room(venueNumber ASC)



CREATE TABLE Track
(
	trackNumber INT NOT NULL IDENTITY, 
	area VARCHAR(100),
	CONSTRAINT PKUnxTrack PRIMARY KEY CLUSTERED(trackNumber)
)

/* link table */
CREATE TABLE TrackOfPresentation
(
	trackNumber INT NOT NULL,
	sessionNumber INT NOT NULL,
	CONSTRAINT PKUnxTrackOfPresentation PRIMARY KEY CLUSTERED(trackNumber,sessionNumber),
	CONSTRAINT FKTrackOfPresentationTrackNumber FOREIGN KEY (trackNumber) REFERENCES Track(trackNumber),
	CONSTRAINT FKTrackOfPresentationSessionNumber FOREIGN KEY (sessionNumber) REFERENCES Presentation(sessionNumber)
)
CREATE NONCLUSTERED INDEX IdxTrackOfPresentationTrackNumber ON TrackOfPresentation(trackNumber ASC)
CREATE NONCLUSTERED INDEX IdxTrackOfPresentationSessionNumber ON TrackOfPresentation(sessionNumber ASC)


/* link table */
CREATE TABLE ScheduleOfClass
(
	eventNumber INT NOT NULL,
	sessionNumber INT NOT NULL,
	roomNumber INT NOT NULL,
	startTime DATETIME NOT NULL,
	endTime DATETIME NOT NULL,
	CONSTRAINT PKUnxScheduleOfClass PRIMARY KEY CLUSTERED(eventNumber,sessionNumber),
	CONSTRAINT FKScheduleOfClassEventNumber FOREIGN KEY (eventNumber) REFERENCES SqlEvent(eventNumber),
	CONSTRAINT FKScheduleOfClassRoomNumber FOREIGN KEY (roomNumber) REFERENCES Room(roomNumber),
	CONSTRAINT FKScheduleOfClassSessionNumber FOREIGN KEY (sessionNumber) REFERENCES Presentation(sessionNumber)
)
CREATE NONCLUSTERED INDEX IdxScheduleOfClassEventNumber ON ScheduleOfClass(eventNumber ASC)
CREATE NONCLUSTERED INDEX IdxScheduleOfClassRoomNumber ON ScheduleOfClass(roomNumber ASC)
CREATE NONCLUSTERED INDEX IdxScheduleOfClassSessionNumber ON ScheduleOfClass(sessionNumber ASC)


/*
 create help table for insert data
*/
CREATE TABLE HelperSponsor
(
	sponsorName VARCHAR(50) NOT NULL, 
	sponsorShipType VARCHAR(30) NOT NULL CONSTRAINT consHelperSponsorShipType CHECK(sponsorShipType IN ('Gold Sponsor','Silver Sponsor','Bronze Sponsor','Platinum Sponsor')) 
)

CREATE TABLE HelperAttendeesRegistration
(
	firstName VARCHAR(75) NOT NULL,
	lastName VARCHAR(75) NOT NULL,
	address1 VARCHAR(100),
	address2 VARCHAR(100),
	city VARCHAR(75),
	zipcode VARCHAR(30),
	personState VARCHAR(50),
	emailAddress VARCHAR(255)
)

CREATE TABLE HelperEvents
(
	eventNumber INT  NOT NULL, 
	eventDate DATE NOT NULL, 
	city VARCHAR(75) NOT NULL, 
	region VARCHAR(100) NOT NULL
)


CREATE TABLE HelperPresentations
(
	title VARCHAR(125) NOT NULL,
	firstName VARCHAR(75) NOT NULL,
	lastName VARCHAR(75) NOT NULL,
	readiness VARCHAR(15) NOT NULL CONSTRAINT consHelperPresentationsReadiness CHECK(readiness IN ('Beginner','Intermediate','Advanced')),
	city VARCHAR(75) NOT NULL
)



/*
 insert data
*/

INSERT INTO HelperSponsor (sponsorName,sponsorShipType)
values
	('VMWare','Platinum Sponsor'),
	('Verizon Digital Media Services','Platinum Sponsor'),
	('Microsoft Corporation (GAP) (GAP Sponsor)','Platinum Sponsor'),
	('Tintri','Platinum Sponsor'),
	('Amazon Web Services, LLC','Gold Sponsor'),
	('Pyramid Analytics (GAP Sponsor)','Gold Sponsor'),
	('Pure Storage','Gold Sponsor'),
	('Profisee','Gold Sponsor'),
	('NetLib Security','Silver Sponsor'),
	('Melissa Data Corp.','Silver Sponsor'),
	('Red Gate Software','Silver Sponsor'),
	('SentryOne','Silver Sponsor'),
	('Hush Hush','Bronze Sponsor'),
	('COZYROC','Bronze Sponsor'),
	('SQLDocKit by Acceleratio Ltd.','Bronze Sponsor')




INSERT INTO HelperAttendeesRegistration
values
	('Amanda','Long','10 Napa Ct.','','Lebanon','97355','Oregon','ALong@gmail.com'),
	('Christian','Shan','1000 Bidweld Street','','Haney','V2W 1W2','British Columbia','CShan@gmail.com'),
	('Troy','Sara','1002 N. Spoonwood Court','','Hervey Bay','4655','Queensland','TSara@gmail.com'),
	('Kaitlyn','Baker','1003 Matterhorn Ct','','Lebanon','97355','Oregon','KBaker@gmail.com'),
	('Suzanne','Ma','1005 Matterhorn Ct.','','Cambridge','CB4 4BZ','England','SMa@gmail.com'),
	('Anna','Jones','1005 Matterhorn Ct.','','Mill Valley','94941','California','AJones@gmail.com'),
	('Carlos','Baker','1005 Tanager Court','','Corvallis','97330','Oregon','CBaker@gmail.com'),
	('Tanya','Munoz','1005 Tanager Court','','Milsons Point','2061','New South Wales','TMunoz@gmail.com'),
	('Tabitha','Gill','1006 Deercreek Ln','','Bellflower','90706','California','TGill@gmail.com'),
	('Alexis','Lee','1006 Deercreek Ln','','Torrance','90505','California','ALee@gmail.com'),
	('Erick','Suri','101 Adobe Dr','','Coffs Harbour','2450','New South Wales','ESuri@gmail.com'),
	('Marcus','Evans','101 Adobe Dr','','Puyallup','98371','Washington','MEvans@gmail.com'),
	('Marcus','Clark','101, avenue de la Gare','','Peterborough','PB12','England','MClark@gmail.com'),
	('Gilbert','Xu','1010 Maple','','Baltimore','21201','Maryland','GXu@gmail.com'),
	('Paula','Rubio','1011 Yolanda Circle','','Berkeley','94704','California','PRubio@gmail.com'),
	('Julian','Isla','1011 Yolanda Circle','','N. Vancouver','V7L 4J4','British Columbia','JIsla@gmail.com'),
	('Jesse','Scott','1013 Holiday Hills Dr.','','Bremerton','98312','Washington','JScott@gmail.com'),
	('Naomi','Sanz','1013 Holiday Hills Dr.','','Gateshead','GA10','England','NSanz@gmail.com'),
	('Isabella','Lee','1015 Lynwood Drive','','Metchosin','V9','British Columbia','ILee@gmail.com'),
	('Dawn','Yuan','1019 Carletto Drive','','Berkeley','94704','California','DYuan@gmail.com'),
	('Olivia','Blue','1019 Mt. Davidson Court','','Burien','98168','Washington','OBlue@gmail.com'),
	('Emmanuel','Lopez','1019 Mt. Davidson Court','','London','SW8 4BG','England','ELopez@gmail.com'),
	('Nathan','Yang','102 Vista Place','','Santa Monica','90401','California','NYang@gmail.com'),
	('Gabrielle','Wood','1020 Book Road','','Bremerton','98312','Washington','GWood@gmail.com'),
	('Katrina','Anand','1020 Carletto Drive','','Matraville','2036','New South Wales','KAnand@gmail.com'),
	('Anthony','Jones','1020 Carletto Drive','','Santa Cruz','95062','California','AJones@gmail.com'),
	('Natalie','Reed','1023 Hawkins Street','','Lebanon','97355','Oregon','NReed@gmail.com'),
	('Dakota','Ross','1024 Walnut Blvd.','','Colma','94014','California','DRoss@gmail.com'),
	('Shawn','Goel','1025 Holly Oak Drive','','Leeds','LE18','England','SGoel@gmail.com'),
	('Nicole','Diaz','1025 R St.','','Kirkland','98033','Washington','NDiaz@gmail.com'),
	('Wyatt','Davis','1025 Yosemite Dr.','','Oregon City','97045','Oregon','WDavis@gmail.com'),
	('Christy','Huang','1028 Green View Court','','Chula Vista','91910','California','CHuang@gmail.com'),
	('Sydney','Evans','1028 Green View Court','','Oregon City','97045','Oregon','SEvans@gmail.com'),
	('Katherine','Baker','1037 Hayes Court','','Stoke-on-Trent','AS23','England','KBaker@gmail.com'),
	('Edward','Wood','1039 Adelaide St.','','West Covina','91791','California','EWood@gmail.com'),
	('Johnny','Rai','104 Hilltop Dr.','','Springwood','2777','New South Wales','JRai@gmail.com'),
	('Emily','Moore','104 Kaski Ln.','','Portland','97205','Oregon','EMoore@gmail.com'),
	('Randy','Yang','1040 Greenbush Drive','','Silverwater','2264','New South Wales','RYang@gmail.com'),
	('Roy','Ruiz','1040 Northridge Road','','London','W1X3SE','England','RRuiz@gmail.com'),
	('Marshall','Sun','1044 San Carlos','','Cincinnati','45202','Ohio','MSun@gmail.com'),
	('Gabriella','Perez','1045 Lolita Drive','','Torrance','90505','California','GPerez@gmail.com'),
	('Erika','Gill','1045 Lolita Drive','','Townsville','4810','Queensland','EGill@gmail.com'),
	('Kathryn','Shen','1047 Las Quebradas Lane','','North Sydney','2055','New South Wales','KShen@gmail.com'),
	('Sharon','Yuan','1048 Burwood Way','','Hervey Bay','4655','Queensland','SYuan@gmail.com'),
	('Victoria','Lee','1048 Las Quebradas Lane','','Walla Walla','99362','Washington','VLee@gmail.com'),
	('Brenda','Arun','1048 Las Quebradas Lane','','Wollongong','2500','New South Wales','BArun@gmail.com'),
	('Alex','Scott','105 Clark Creek Lane','','Port Macquarie','2444','New South Wales','AScott@gmail.com'),
	('Yolanda','Luo','105 Woodruff Ln.','','Bellingham','98225','Washington','YLuo@gmail.com'),
	('Martin','Vance','1050 Creed Ave','','London','W10 6BL','England','MVance@gmail.com'),
	('Jeremy','Roberts','081, boulevard du Montparnasse','','Seattle','98104','Washington','JRoberts@yahoo.com'),
	('Amanda','Ramirez','1 Smiling Tree Court','Space 55','Los Angeles','90012','California','ARamirez@yahoo.com'),
	('Jada','Nelson','100, rue des Rosiers','','Everett','98201','Washington','JNelson@yahoo.com'),
	('Hunter','Wright','1002 N. Spoonwood Court','','Berkeley','94704','California','HWright@yahoo.com'),
	('Sierra','Wright','1005 Fremont Street','','Colma','94014','California','SWright@yahoo.com'),
	('Sarah','Simmons','1005 Valley Oak Plaza','','Langley','V3A 4R2','British Columbia','SSimmons@yahoo.com'),
	('Mandar','Samant','1005 Valley Oak Plaza','','London','SW6 SBY','England','MSamant@yahoo.com'),
	('Isaiah','Rogers','1007 Cardinet Dr.','','El Cajon','92020','California','IRogers@yahoo.com'),
	('Ian','Foster','1008 Lydia Lane','','Burbank','91502','California','IFoster@yahoo.com'),
	('Ben','Miller','101 Candy Rd.','','Redmond','98052','Washington','BMiller@yahoo.com'),
	('Sarah','Barnes','1011 Green St.','','Bellingham','98225','Washington','SBarnes@yahoo.com'),
	('Casey','Martin','1013 Buchanan Rd','','Port Macquarie','2444','New South Wales','CMartin@yahoo.com'),
	('Victoria','Murphy','1013 Buchanan Rd','','Yakima','98901','Washington','VMurphy@yahoo.com'),
	('Sydney','Rogers','1016 Park Avenue','','Burbank','91502','California','SRogers@yahoo.com'),
	('Marvin','Hernandez','1019 Book Road','','Rhodes','2138','New South Wales','MHernandez@yahoo.com'),
	('Carlos','Carter','1019 Buchanan Road','','Woodland Hills','91364','California','CCarter@yahoo.com'),
	('Rebekah','Garcia','1019 Candy Rd.','','Coffs Harbour','2450','New South Wales','RGarcia@yahoo.com'),
	('Haley','Henderson','1019 Chance Drive','','Sedro Woolley','98284','Washington','HHenderson@yahoo.com'),
	('Jacob','Taylor','1019 Kenwal Rd.','','Lake Oswego','97034','Oregon','JTaylor@yahoo.com'),
	('Seth','Martin','1019 Pennsylvania Blvd','','Marysville','98270','Washington','SMartin@yahoo.com'),
	('Larry','Suarez','102 Vista Place','','Milton Keynes','MK8 8DF','England','LSuarez@yahoo.com'),
	('Garrett','Vargas','10203 Acorn Avenue','','Calgary','T2P 2G8','Alberta','GVargas@yahoo.com'),
	('Abby','Martinez','1023 Hawkins Street','','Townsville','4810','Queensland','AMartinez@yahoo.com'),
	('Justin','Thomas','1023 Riveria Way','','Burbank','91502','California','JThomas@yahoo.com'),
	('Evelyn','Martinez','1023 Riviera Way','','Oxford','OX1','England','EMartinez@yahoo.com'),
	('Pamela','Chapman','1025 Yosemite Dr.','','Townsville','4810','Queensland','PChapman@yahoo.com'),
	('Kayla','Griffin','1026 Mt. Wilson Pl.','','Lynnwood','98036','Washington','KGriffin@yahoo.com'),
	('Jill','Navarro','1026 Mt. Wilson Pl.','','South Melbourne','3205','Victoria','JNavarro@yahoo.com'),
	('Nathan','Walker','1028 Indigo Ct.','','Issaquah','98027','Washington','NWalker@yahoo.com'),
	('Tabitha','Moreno','1028 Indigo Ct.','','Warrnambool','3280','Victoria','TMoreno@yahoo.com'),
	('Mason','Sanchez','1028 Royal Oak Rd.','','Burlingame','94010','California','MSanchez@yahoo.com'),
	('Natasha','Navarro','1029 Birchwood Dr','','Burien','98168','Washington','NNavarro@yahoo.com'),
	('Kevin','Russell','1029 Birchwood Dr','','Olympia','98501','Washington','KRussell@yahoo.com'),
	('Katelyn','Rivera','1030 Ambush Dr.','','Bury','PE17','England','KRivera@yahoo.com'),
	('Alfredo','Ortega','1032 Buena Vista','','North Ryde','2113','New South Wales','AOrtega@yahoo.com'),
	('Andrea','Campbell','1032 Coats Road','','Stoke-on-Trent','AS23','England','ACampbell@yahoo.com'),
	('Jeremy','Peterson','1035 Arguello Blvd.','','San Diego','92102','California','JPeterson@yahoo.com'),
	('Arianna','Ramirez','1036 Mason Dr','','Port Orchard','98366','Washington','ARamirez@yahoo.com'),
	('Mario','Sharma','1039 Adelaide St.','','Port Macquarie','2444','New South Wales','MSharma@yahoo.com'),
	('Adam','Collins','104 Hilltop Dr.','','Concord','94519','California','ACollins@yahoo.com'),
	('Taylor','Martin','1040 Greenbush Drive','','Newton','V2L3W8','British Columbia','TMartin@yahoo.com'),
	('Gabriel','Collins','1040 Northridge Road','','Woodland Hills','91364','California','GCollins@yahoo.com'),
	('Randall','Martin','1042 Hooftrail Way','','Newcastle','2300','New South Wales','RMartin@yahoo.com'),
	('Samantha','Jenkins','1046 Cloverleaf Circle','','Shawnee','V8Z 4N5','British Columbia','SJenkins@yahoo.com'),
	('Justin','Simmons','1046 San Carlos Avenue','','Colma','94014','California','JSimmons@yahoo.com'),
	('Ethan','Winston','1047 Las Quebradas Lane','','Oak Bay','V8P','British Columbia','EWinston@yahoo.com'),
	('Hunter','Roberts','1048 Burwood Way','','Haney','V2W 1W2','British Columbia','HRoberts@yahoo.com'),
	('Nathaniel','Murphy','105 Woodruff Ln.','','Oakland','94611','California','NMurphy@yahoo.com'),
	('Charles','Wilson','1050 Creed Ave','','Lebanon','97355','Oregon','CWilson@yahoo.com'),
	('Carrie','Alvarez','1050 Greenhills Circle','','Lane Cove','1597','New South Wales','CAlvarez@yahoo.com'),
	('Paige','Alexander','1050 Greenhills Circle','','Langley','V3A 4R2','British Columbia','PAlexander@yahoo.com')



INSERT INTO HelperEvents (eventDate,eventNumber,city,region)
VALUES 
	('05/06/17',626,'Budapest','Europe/Middle East/Africa'),
	('05/06/17',615,'Baltimore','Canada/US'),
	('05/13/17',608,'Bogota','Latin America'),
	/* 
	 There is a typo in the file, in the event file it's Kyiv
	 in the presentation file it's Kiyv
	*/
	('05/20/17',616,'Kyiv','Europe/Middle East/Africa'),
	('05/20/17',588,'New York','Canada/US'),
	('05/27/17',630,'Brisbane','Asia Pacific'),
	('05/27/17',599,'Plovdiv','Europe/Middle East/Africa'),
	('06/03/17',638,'Philadelphia','Canada/US'),
	/*
	  City Kiev is in the presentation file
	  but there is no events happend in Kiev displayed in the Events file
	  I add a dummy Event here so we can keep the integrity of the presentations
	 */
	( '01/01/17',-1,'Kiev','')

/*
 I noticed there is one row called Registrations
 another row called Raffle.
 For the registration, I didn't find the description in the "SQL Saturday Description.docx" file.
 For Raffle, I didn't provide information about the raffle, no information about the gift in the raffel
 no information about which sponsors provide gift.
 So I just comment these two lines out.
*/

/*
 Some rows are 'non-tech' they are not presentation ( like 'Coffee Break').
 So I didn't treat them as presentation.
*/
INSERT INTO HelperPresentations
VALUES
	('A dive into Data Quality Services','Steve','Simon','Intermediate','New York'),
	('A Dynamic World Demands Dynamic SQL','Jeremiah','Peschka','Intermediate','Kyiv'),
	('A Dynamic World Demands Dynamic SQL','Jeremiah','Peschka','Intermediate','Kyiv'),
	('Absolute Introductory Session on SQL Server 2014 In-Memory Optimized Databases (Hekaton)','Kevin','Goff','Beginner','Budapest'),
	('AlwaysOn: Improve reliability and reporting performance with one cool tech','Chris','Seferlis','Beginner','New York'),
	('An introduction to Data Mining','Steve','Simon','Intermediate','Kyiv'),
	('An Introduction to Database Design','Mohammad','Yusuf','Beginner','New York'),
	('Autogenerating a process data warehouse','Kennie','Pontoppidan','Advanced','New York'),
	('Automate your daily checklist with PBM and CMS','John','Sterrett','Intermediate','Budapest'),
	('Automated Installing and Configuration of SQL2014/SQL2012 AlwaysOn Across Multiple Datacenters','Thomas','Grohser','Intermediate','New York'),
	('Automated Installing and Configuration of SQL2014/SQL2012 AlwaysOn Across Multiple Datacenters','Thomas','Grohser','Intermediate','Kiev'),
	('Automating Execution Plan Analysis','Joe','Chang','Advanced','Kiev'),
	('Automating Execution Plan Analysis','Joe','Chang','Advanced','New York'),
	('Automating SQL Server using PowerShell','Michael','Wharton','Intermediate','New York'),
	('Balanced Scorecards using SSRS','Sunil','Kadimdiwan','Intermediate','Budapest'),
	('Baselines and Performance Monitoring with PAL','Mike','Walsh','Beginner','New York'),
	('Basic Database Design','John','Miner','Beginner','New York'),
	('Basic Database Programming','John','Miner','Beginner','Kiev'),
	('Become a BI Independent Consultant!','James','Serra','Beginner','Budapest'),
	('Becoming a Top DBA--Learning Automation in SQL Server','Joseph','D''Antoni','Beginner','Kiev'),
	('Best Practices Document','Paresh','Motiwala','Intermediate','Kiev'),
	('Best Practices for Efficient SSRS Report Creation','Mickey','Stuewe','Beginner','New York'),
	('Biggest Loser: Database Edition','John','Miner','Intermediate','New York'),
	('Building a BI Solution in the Cloud','Stacia','Misner','Intermediate','Budapest'),
	('Building an Effective Data Warehouse Architecture','James','Serra','Beginner','New York'),
	('Building an Effective Data Warehouse Architecture with the cloud and MPP','James','Serra','Beginner','New York'),
	('Bulk load and minimal logged inserts','David','Peter Hansen','Advanced','New York'),
	('Business Analytics with SQL Server & Power Map:Everything you want to know but were afraid to ask','Steve','Simon','Intermediate','New York'),
	('Challenges to designing financial warehouses, lessons learnt','Steve','Simon','Intermediate','New York'),
	('Change Data Capture in SQL Server 2008/2012','Kevin','Goff','Intermediate','New York'),
	('Changing Your Habits to Improve the Performance of Your T-SQL','Mickey','Stuewe','Beginner','Kiev'),
	('Clusters Your Way: #SANLess Clusters for Physical, Virtual, and Cloud Environments','Allan','Hirt and SIOS Technology','Beginner','Kiev'),
	/*
	('Clusters Your Way: #SANLess Clusters for Physical, Virtual, and Cloud Environments','Allan','Hirt','Non-Technical','Kiev'),
	('Coffee Break','SQLSatruday','364','Non-Technical','Budapest'),
	*/
	('Creating A Performance Health Repository - using MDW','Robert','Pearl','Beginner','Kiev'),
	('Creating efficient and effective SSRS BI Solutions','Steve','Simon','Intermediate','Kiev'),
	('Creating efficient and effective SSRS BI Solutions','Steve','Simon','Intermediate','New York'),
	('Data Partitioning','John','Flannery','Intermediate','New York'),
	('Data Tier Application Testing with NUnit and Distributed Replay','John','Flannery','Intermediate','New York'),
	('Database design for mere developers','Steve','Simon','Intermediate','Budapest'),
	('Database design for mere developers','Steve','Simon','Intermediate','New York'),
	('Database Design: Solving Problems Before they Start!','Edward','Pollack','Beginner','New York'),
	('Database Modeling and Design','Mohammad','Yusuf','Intermediate','New York'),
	('Database Virtualization and Drinking out of the Fire Hose','Michael','Corey','Intermediate','New York'),
	('DAX and the tabular model','Steve','Simon','Intermediate','Kiev'),
	('DBA FOR DUMMIES','Robert','Pearl','Beginner','Budapest'),
	('Dealing With Difficult People','Gigi','Bell','Beginner','Kiev'),
	('Development Lifecycle with SQL Server Data Tools and DACFx','John','Flannery','Intermediate','Kiev'),
	('Did You Vote Today? A DBAs Guide to Cluster Quorum','Allan','Hirt','Advanced','Kiev'),
	('Dimensional Modeling Design Patterns: Beyond Basics','Jason','Horner','Intermediate','Kiev'),
	('Dimensional Modeling Design Patterns: Beyond Basics','Jason','Horner','Intermediate','Budapest'),
	('Diving Into Query Execution Plans','Edward','Pollack','Intermediate','New York'),
	('Dynamic SQL: Writing Efficient Queries on the Fly','Edward','Pollack','Beginner','Kiev'),
	('Easy Architecture Design for HA and DR','Brent','Ozar','Intermediate','New York'),
	('Enhancing your career: Building your personal brand','James','Serra','Beginner','New York'),
	('Establishing a SLA','Thomas','Grohser','Intermediate','New York'),
	('ETL not ELT! Common mistakes and misconceptions about SSIS','Paul','Rizza','Advanced','Budapest'),
	/*
	('Event Kickoff and Networking','SQLSaturday','364','Non-Technical','New York'),
	*/
	('Execution Plans: What Can You Do With Them?','Grant','Fritchey','Intermediate','New York'),
	('Faster, Better Decisions with Self Service Business Analytics','Sayed','Saeed','Intermediate','New York'),
	('Full Text Indexing Basics','John','Miner','Beginner','Budapest'),
	('Get your Mining Model Predictions out to all','Steve','Simon','Intermediate','New York'),
	/*
	('Getting a job with Microsoft','Paul','Rizza','Non-Technical','New York'),
	*/
	('Graph Databases for SQL Server Professionals','Sthane','Frhette','Intermediate','New York'),
	('Hacking Expos?- Using SSL to Protect SQL Connections','Chris','Bell','Intermediate','New York'),
	('Hacking the SSIS 2012 Catalog','Andy','Leonard','Beginner','Budapest'),
	('Hidden in plain sight: master your tools','Varsham','Papikian','Intermediate','New York'),
	('Highly Available SQL Server in Windows Azure IaaS','David','Bermingham','Intermediate','New York'),
	('How to Make a LOT More Money as a Consultant','James','Serra','Beginner','New York'),
	('How to Think Like the Engine','Brent','Ozar','Intermediate','New York'),
	('Hybrid Cloud Scenarios with SQL Server 2014','George','Walters','Intermediate','Budapest'),
	('Hybrid Solutions: The Future of SQL Server Disaster Recovery','Allan','Hirt','Intermediate','Budapest'),
	('Implementing Data Warehouse Patterns with the Microsoft BI Tools','Kevin','Goff','Intermediate','Budapest'),
	('Inroduction to Triggers','Jack','Corbett','Beginner','Budapest'),
	('Integrating Reporting Services with SharePoint','Kevin','Goff','Intermediate','New York'),
	('Integration Services (SSIS) for the DBA','David','Peter Hansen','Intermediate','New York'),
	('Introducing Power BI','Stacia','Misner','Beginner','New York'),
	('Introduction to Database Recovery','John','Flannery','Beginner','New York'),
	('Introduction to High Availability with SQL Server','John','Sterrett','Beginner','New York'),
	('Introduction to Powershell for DBA''s','John','Sterrett','Beginner','New York'),
	('Introduction to SQL Server - Part 1','Brandon','Leach','Beginner','New York'),
	('Introduction to SQL Server - Part 2','Brandon','Leach','Beginner','New York'),
	('Is That A Failover Cluster On Your Laptop/Desktop?','Allan','Hirt','Intermediate','New York'),
	('Leaving the Windows Open','Jeremiah','Peschka','Intermediate','New York'),
	/*
	('Lunch Break','SQLSaturday','364','Non-Technical','New York'),
	('Lunchtime Keynote','SQLSaturday','364','Non-Technical','New York'),
	*/
	('Master Data Services Best Practices','Steve','Simon','Intermediate','New York'),
	('Master Data Services Disaster Recovery','Steve','Simon','Intermediate','New York'),
	('Mind your language!! Cursors are a dirty word','Steve','Simon','Intermediate','New York'),
	('Modern Data Warehousing','James','Serra','Beginner','New York'),
	('Monitoring Server health via Reporting Services dashboards','Steve','Simon','Intermediate','New York'),
	('Monitoring SQL Server using Extended Events','Hilary','Cotter','Beginner','New York'),
	('Multidimensional vs Tabular - May the Best Model Win','Stacia','Misner','Intermediate','New York'),
	('Murder They Wrote','Jason','Brimhall','Intermediate','New York'),
	('Never Have to Say "Mayday!!!" Again','Mike','Walsh','Beginner','New York'),
	('Now you see it! Now you don’t! Conjuring many reports utilizing only one SSRS report.','Steve','Simon','Intermediate','New York'),
	/*
	('Optimal Infrastructure Strategies for Cisco UCS, Nexus and SQL Server','Kevin','Schenega','Non-Technical','Budapest'),
	*/
	('Optimizing Protected Indexes','Chris','Bell','Intermediate','Budapest'),
	('Partitioning as a design pattern','Kennie','Pontoppidan','Advanced','Budapest'),
	('Power BI Components in Microsoft''s Self-Service BI Suite','Todd','Chittenden','Beginner','New York'),
	('Power to the people!!','Steve','Simon','Intermediate','Kyiv'),
	('PowerShell Basics for SQLServer','Michael','Wharton','Beginner','Kyiv'),
	('PowerShell for the Reluctant DBA / Developer','Jason','Horner','Beginner','Kyiv'),
	('Prevent Recovery Amnesia ?Forget the Backups','Chris','Bell','Beginner','Kyiv'),
	('Query Optimization Crash Course','Edward','Pollack','Beginner','Kyiv'),
	/*
	('Raffle','SQLSaturday','364','Non-Technical',''),
	*/
	('Rapid Application Development with Master Data Services','Steve','Simon','Intermediate','Kyiv'),
	('Recovery and Backup for Beginners','Mike','Hillwig','Beginner','Kyiv'),
	('Reduce, Reuse, Recycle: Automating Your BI Framework','Stacia','Misner','Intermediate','Kyiv'),
	/*
	('Registrations','SQLSaturday','364','Non-Technical',''),
	*/
	('Replicaton Technologies','Hilary','Cotter','Advanced','Kyiv'),
	('Reporting Services for Mere DBAs','Jason','Brimhall','Intermediate','Kyiv'),
	('Scaling with SQL Server Service Broker','Hilary','Cotter','Advanced','Kyiv'),
	('Scaling with SQL Server Service Broker','Hilary','Cotter','Advanced','Kyiv'),
	('Self-Service Data Integration with Power Query','Sthane','Frhette','Beginner','Kyiv'),
	('Shortcuts to Building SSIS in .Net','Paul','Rizza','Beginner','Kyiv'),
	('So You Want To Be A Consultant?','Allan','Hirt','Beginner','Kyiv'),
	('SQL anti patterns','Kennie','Pontoppidan','Advanced','Kyiv'),
	('SQL Server 2012/2014 Columnstore index','Kevin','Goff','Intermediate','Kyiv'),
	('SQL Server 2012/2014 Performance Tuning All Up','George','Walters','Intermediate','Kyiv'),
	('SQL Server 2014 Data Access Layers','Steve','Simon','Intermediate','Kyiv'),
	('SQL Server 2014 New Features','George','Walters','Intermediate','Kyiv'),
	('SQL Server AlwaysOn Availability Groups','George','Walters','Beginner','Kyiv'),
	('SQL Server and the Cloud','David','Peter Hansen','Beginner','Kyiv'),
	('SQL Server Compression and what it can do for you','Jason','Brimhall','Advanced','Kyiv'),
	('SQL Server Reporting Services 2014 on Steroids!!','Steve','Simon','Intermediate','Kyiv'),
	('SQL Server Reporting Services Best Practices','Steve','Simon','Intermediate','Kyiv'),
	('SQL Server Reporting Services, attendees choose','Kevin','Goff','Intermediate','Kyiv'),
	('SQL Server Storage Engine under the hood','Thomas','Grohser','Intermediate','Kyiv'),
	('SQL Server Storage internals: Looking under the hood.','Brandon','Leach','Advanced','Kyiv'),
	('SSIS 2014 Data Flow Tuning Tips and Tricks','Andy','Leonard','Beginner','Kyiv'),
	('Standalone to High-Availability Clusters over Lunch—with Time to Spare','Carl','Berglund','Intermediate','Budapest'),
	('Stress testing SQL Server','Hilary','Cotter','Advanced','Kyiv'),
	('Table partitioning for Azure SQL Databases','John','Miner','Beginner','Kyiv'),
	('Testing','Melissa','Riley','Beginner','Kyiv'),
	('The future of the data professional','Adam','Jorgensen','Beginner','Kyiv'),
	('The Quest for the Golden Record:MDM Best Practices','Dennis','Messina','Beginner','Budapest'),
	('The Quest to Find Bad Data With Data Profiling','Richie','Rump','Intermediate','Budapest'),
	('The Spy Who Loathed Me - An Intro to SQL Security','Chris','Bell','Beginner','Budapest'),
	('Tired of the CRUD? Automate it!','Jack','Corbett','Intermediate','Budapest'),
	('Top 5 Ways to Improve Your triggers','Aaron','Bertrand','Intermediate','Budapest'),
	('Tricks that have saved my bacon','Greg','Moore','Beginner','Budapest'),
	('T-SQL : Bad Habits & Best Practices','Aaron','Bertrand','Beginner','Budapest'),
	('T-SQL for Application Developers - Attendees chose','Kevin','Goff','Intermediate','Budapest'),
	('Tune Queries By Fixing Bad Parameter Sniffing','Grant','Fritchey','Intermediate','Budapest'),
	('Using Extended Events in SQL Server','Jason','Brimhall','Advanced','Budapest'),
	('Watch Brent Tune Queries','Brent','Ozar','Intermediate','Budapest'),
	('What every SQL Server DBA needs to know about Windows Server 10 Technical Preview','David','Bermingham','Intermediate','Budapest'),
	('What exactly is big data and why should I care?','James','Serra','Beginner','Budapest'),
	('What is it like to work for Microsoft?','James','Serra','Beginner','Budapest'),
	('What''s new in SQL Server Integration Services 2012','Kevin','Goff','Intermediate','Budapest'),
	('Why do we shun using tools for DBA job?','Paresh','Motiwala','Intermediate','Budapest'),
	('Why OLAP? Building SSAS cubes and benefits of OLAP','Kevin','Goff','Intermediate','Budapest'),
	('You''re Doing It Wrong!!','Mike','Walsh','Intermediate','Budapest')



/*
	move the data from Helper table to real table
*/

INSERT INTO Sponsor (sponsorName,sponsorShipType)
SELECT sponsorName, sponsorShipType FROM HelperSponsor

/*
  We don't have Venue number in the file, because of the Not Null properity and foreign key constraint  
  I will just fake a Venue, so we can continutest. Just assume all the Events in the same Venue for test
*/

INSERT INTO Venue(city,venueAddress,venueName)
VALUES ('Northridge','111 ABC STREET','TEST VENUE')

/*  venueNumber is not specified, set to 1 */
INSERT INTO SqlEvent (eventNumber,eventDate,venueNumber,city,region)
SELECT eventNumber,eventDate,1,city,region FROM HelperEvents


/* Insert all attendees in to person table */
INSERT INTO Person(firstName,lastName,address1,address2,city,zipcode,personState,emailAddress)
SELECT firstName,lastName,address1,address2,city,zipcode,personState,emailAddress FROM HelperAttendeesRegistration

/* insert the personNumber who is an attendee  into Attendee table*/
INSERT INTO Attendee(personNumber)
SELECT Person.personNumber FROM Person
INNER JOIN HelperAttendeesRegistration ON 
(
	Person.firstName=HelperAttendeesRegistration.firstName 
	AND Person.lastName=HelperAttendeesRegistration.lastName 
)

/* 
  HelperPresentations has some duplicated person( one person give more than one lecture ). 
  So I use group by to eliminate the duplicate
*/
/* Insert presenter into people table */
INSERT INTO Person(firstName,lastName)
(
SELECT firstName,lastName FROM HelperPresentations
GROUP BY firstName,lastName
)


/* 
  HelperPresentations has some duplicated person( one person give more than one lecture ). 
  So I use group by to eliminate the duplicate
*/
/* insert the personNumber who is a presenter  into Presenter table*/
INSERT INTO Presenter(personNumber)
SELECT Person.personNumber FROM Person
INNER JOIN HelperPresentations ON 
(
	Person.firstName=HelperPresentations.firstName 
	AND Person.lastName=HelperPresentations.lastName 
)
/* Some presenter has same name */
GROUP BY Person.personNumber


/*
 Insert the class information into Presentation table. 
 The Presentation table has the eventNumber, the SqlEvent table contain the city informaion. 
 */
INSERT INTO Presentation(title,topic,presentationDescription,readiness)
SELECT title,'','',readiness FROM HelperPresentations
INNER JOIN SqlEvent ON SqlEvent.city=HelperPresentations.city
GROUP BY title,readiness

/*
  We don't have room number in the file, because of the Not Null properity and foreign key constraint  
  I will just fake a room, so we can continutest. Just assume all the class in the same room for test
*/

INSERT INTO Room(venueNumber,capacity)
VALUES (1,1000)

/*  
 For the start time,end time , I just use current datatime
 Since some rows in the "Presentations.xlsx" are exactly the same, I use GROUP BY to eliminate the duplicate.
 For example, the second presentation and third presentation in the file are exactly the same
*/
INSERT INTO ScheduleOfClass (eventNumber,sessionNumber,roomNumber,startTime,endTime)
SELECT SqlEvent.eventNumber, Presentation.sessionNumber,1,getdate(),getdate() FROM HelperPresentations
INNER JOIN  SqlEvent ON SqlEvent.city=HelperPresentations.city
INNER JOIN Presentation ON Presentation.title=HelperPresentations.title
GROUP BY SqlEvent.eventNumber, Presentation.sessionNumber



/*
 Fill the PresenterPresentSession table to link the presenter with the presentation
 */
  /* 
	I try to use INNER JOIN here. Then I found use where clause is more straightforward
  */

 /* 
  HelperPresentations has some duplicated rows 
  So I use group by to eliminate the duplicate
 */

INSERT INTO PresenterPresentSession
SELECT presenterNumber, Presentation.sessionNumber  FROM Presenter,Person,SqlEvent,Presentation,HelperPresentations,ScheduleOfClass
WHERE Presenter.personNumber=Person.personNumber
AND   SqlEvent.eventNumber=ScheduleOfClass.eventNumber
AND   Presentation.title=HelperPresentations.title
AND   Person.firstName=HelperPresentations.firstName 
AND   Person.lastName=HelperPresentations.lastName
AND   SqlEvent.city=HelperPresentations.city

GROUP BY presenterNumber,Presentation.sessionNumber

/*
 Since we don't have the track information, I just make up a track called "database" 
 So we can test the procedure that selects presentations per track in the Budapest
*/
INSERT INTO Track
VALUES ('database')

/* all the presentation will be in the "database" track */
INSERT INTO TrackOfPresentation (trackNumber,sessionNumber)
SELECT 1, sessionNumber FROM Presentation


GO

/*
 procedures
*/

/*
  selects presentations per track in the Budapest
  Since there is 8 table I need to join inorder to get the result
  I use WHERE clause, which is more straightforward to me compare to using nested INNER JOIN.
*/

/*
 Since I just create one track(database), all class are in the same track in this result 
 If we have more track, this procedure will classify the presentation according to the track
*/


CREATE PROC showPresentationsAtBudapest
AS
BEGIN TRY
	SELECT area AS track,SqlEvent.city,Presentation.title, firstName, lastName FROM Presentation,SqlEvent,ScheduleOfClass,Presenter,Person,PresenterPresentSession, Track, TrackOfPresentation
	WHERE SqlEvent.eventNumber=ScheduleOfClass.eventNumber
	AND ScheduleOfClass.sessionNumber=Presentation.sessionNumber
	AND SqlEvent.city IN ('Budapest')
	AND Presenter.presenterNumber=PresenterPresentSession.presenterNumber
	AND PresenterPresentSession.sessionNumber=Presentation.sessionNumber
	AND Person.personNumber=Presenter.personNumber
	AND Track.trackNumber=TrackOfPresentation.trackNumber
	AND TrackOfPresentation.sessionNumber=Presentation.sessionNumber
END TRY
BEGIN CATCH  
    SELECT  
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage
END CATCH
GO

/* test the procedure */
EXEC showPresentationsAtBudapest
GO

/*
create insert procedure that inserts presentation(s) and its speakers.
*/


CREATE PROC insertPresentation

@name VARCHAR(255)='',
@presentation VARCHAR(255)=''
AS
BEGIN TRY
	DECLARE @fName VARCHAR(255)
	DECLARE @lName VARCHAR(255)
	DECLARE @indexOfSpace INT
	DECLARE @personNum INT
	DECLARE @presenterNumb INT
	DECLARE @presentationNum INT

	/*
	 get first name and last name to insert into person table
	*/
	SET @indexOfSpace =  CHARINDEX(' ',@name)
	SET @fName = SUBSTRING(@name,0,@indexOfSpace)
	SET @lName = SUBSTRING(@name,@indexOfSpace+1,LEN(@name))
	/*
	 insert the name into person table and get personNumber
	*/
	INSERT INTO Person(firstName,lastName)
	VALUES (@fName,@lName)
	SET @personNum= (SELECT Person.personNumber FROM Person
		WHERE Person.firstName=@fName AND Person.lastName=@lName)
	/*
	 Since this person is presenter, we need to add this person in to Presenter table 
	 then get presenterNumber
	*/
	INSERT INTO Presenter(personNumber)
	VALUES (@personNum)
	SET @presenterNumb= (SELECT Presenter.presenterNumber FROM Presenter
		WHERE Presenter.personNumber=@personNum)
	/*
	 Now we have presenter number already
	 Next we will insert the presentation into Presentation table and get the presentationNumebr
	*/
	INSERT INTO Presentation(title,topic,presentationDescription,readiness)
	VALUES (@presentation,'','','Beginner')
	SET @presentationNum= (SELECT Presentation.sessionNumber FROM Presentation
		WHERE Presentation.title=@presentation)
	/*
	 Now we have the presenter number and session number
	 Since we just have the information about presenter name and the title of presentation
	 No information about the event, the track, venue, room......
	 So the last thing we need to do is insert the presenter number and session number
	 into PresenterPresentSession (a link table)
	*/
	INSERT INTO PresenterPresentSession (presenterNumber,sessionNumber)
	VALUES(@presenterNumb,@presentationNum)

END TRY
BEGIN CATCH  
    SELECT  
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage
END CATCH
GO


/* 
 the following lines can be used to test the insert procedure, 
 I didn't execute next line in this database yet(s17guest14).
 So presenter 'Jingjie Zhang',  presentation 'zComputer science' is not inserted in the database yet
 But I have tested this code in my local database.
 You can execute next line to test insert procedure
 */
EXEC insertPresentation 'Jingjie Zhang','zComputer science'
/*
 Simple test to display the presentation and the presenter we just inserted
*/
Select firstName,lastName,title  FROM Person,Presenter,Presentation,PresenterPresentSession
WHERE Person.personNumber=Presenter.personNumber
AND PresenterPresentSession.presenterNumber=Presenter.presenterNumber
AND PresenterPresentSession.sessionNumber=Presentation.sessionNumber
AND Presentation.title='zComputer science'

GO


/*
 Create a Full Database Backup to local disk
*/

USE s17guest14;
GO
BACKUP DATABASE s17guest14
TO DISK = 'C:\SQLServerBackups\SQLSatuarday.Bak'
   WITH FORMAT,
      MEDIANAME = 'Z_SQLServerBackups',
      NAME = 'Full Backup of SQLSatuarday';
GO



