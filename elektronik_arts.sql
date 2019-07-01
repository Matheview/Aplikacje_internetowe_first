-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 30 Maj 2019, 00:42
-- Wersja serwera: 10.1.36-MariaDB
-- Wersja PHP: 7.2.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `elektronik_arts`
--

DELIMITER $$
--
-- Funkcje
--
CREATE DEFINER=`root`@`localhost` FUNCTION `generate_passwd` (`mail` VARCHAR(64), `hash_passwd` VARCHAR(255), `gen_passwd` VARCHAR(255)) RETURNS TINYINT(1) NO SQL
BEGIN
    IF EXISTS(SELECT user_id FROM users WHERE email=mail) THEN
        UPDATE users SET passwd=hash_passwd, updated_at=NOW() WHERE 					email=mail;
        INSERT INTO gen_passwd_log(email, passwd, created_at) VALUES (mail, 			gen_passwd, NOW());
        RETURN true;
    ELSE
        RETURN false;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `login_user` (`login` VARCHAR(64), `password` VARCHAR(256)) RETURNS TINYINT(1) NO SQL
    COMMENT 'logowanie użytkowników do aplikacji'
BEGIN
    IF EXISTS(SELECT * FROM users WHERE email=login AND passwd=password) THEN
    	RETURN TRUE;
    ELSE
    	RETURN False;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `articles`
--

CREATE TABLE `articles` (
  `article_id` bigint(20) NOT NULL,
  `article_num` int(11) NOT NULL,
  `article_desc` varchar(64) COLLATE utf8_polish_ci NOT NULL,
  `desc_short` text COLLATE utf8_polish_ci NOT NULL,
  `desc_long` text COLLATE utf8_polish_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `picture` varchar(64) COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Zrzut danych tabeli `articles`
--

INSERT INTO `articles` (`article_id`, `article_num`, `article_desc`, `desc_short`, `desc_long`, `created_at`, `updated_at`, `picture`) VALUES
(1, 110000, 'Wireless Weather Station', 'Building a Wireless Weather Station is a great learning experience. When you finish building this project, you will have a better understanding of how wireless communications works, how sensors work, and how powerful the Arduino platform can be. With this project as a base and the experience gained, you will be able to easily build more complex projects in the future.', 'Hi guys, today we will be building a very interesting Arduino project, a wireless weather station using the ultra fast Arduino Due, a DHT22 temperature and humidity sensor and the NRF24L01 RF Transceiver communication module. <br><br>\r\n\r\n\r\nThe project is a two part project as we will be building two devices; the monitoring station, and the outdoor sensor. he monitoring station is enabled for wireless communication, it receives weather data from the outdoor sensor and displays it on the attached 3.2″ Color TFT display. The station is built using the fast 32bit Arduino Due, a big 3.2” Color TFT display, DS3231 real time clock, NRF24L01 and a DHT22 temperature and humidity sensor which is used to determine the indoor temperature and humidity. Asides the temperature and humidity from both the outdoor sensor and the DHT22 attached to the weather station, the station also displays the current time and date. The readings of the outdoor sensor are received by the weather station every second in order to show that we have a reliable communication link established between the weather station and the outdoor sensor. The Indoor temperature and humidity from the indoor sensor however, is updated every minute since it is directly connected to the weather station and there is no need to ensure connection.<br>\r\n<iframe width=\"100%\" height=\"100%\" src=\"https://www.youtube.com/embed/MCc_1IcJZPw\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe><br>\r\nThe transmitter(outdoor sensor) is much simpler. It consists of an Arduino Nano, a DHT22 sensor and the NRF24L01 wireless transceiver module. The device reads the temperature and the humidity every second, and sends them via the NRF24L01 module to the weather station. The communication is a one way link, thus it is impossible to verify if the data was received by the monitoring station or not. I didn’t bother too much about this since its just for learning purpose, but I would have implemented an algorithm (Acknowledgement) to confirm delivery if this was a product to be released to the public.<br>\r\nTo more information click <a href=\"http://educ8s.tv/arduino-wireless-weather-station/\">here</a> to get more informations<br>\r\n<i>educ8s.tv</i>', '2019-05-29 23:25:29', '2019-05-29 23:25:29', 'projekt2.png'),
(2, 110001, 'Arduino-controlled lie detector', 'Hey everyone today I want to show you how to make an Arduino-controlled lie detector to see when your friends are lying to you :D or to measure the different responses that your bodies skingoes through depending onthe situation you are in or the emotions you are feeling and the coolest thing of all is that we can see all of theses things happen in real time in an Arduino graph.', 'Hey everyone today I want to show you how to make an Arduino-controlled lie detector to see when your friends are lying to you :D or to measure the different responses that your bodies skingoes through depending onthe situation you are in or the emotions you are feeling and the coolest thing of all is that we can see all of theses things happen in real time in an Arduino graph. <br><br>\r\n<iframe width=\'100%\' height=\'100%\' src=\'https://www.youtube.com/embed/8ogMm94AH80\' frameborder=\'0\' allow=\'accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\' allowfullscreen></iframe><br>\r\n\r\nOur skin is amazing! It provides a medium for us to experience the sense of touch, it keeps infections out and keeps innards in but I bet you didn\'t know that our skin changes conductivity depending on many different things one being our mood! It called Electrodermal activity (EDA) and there\'s a really interesting Wikipedia page you can read here. The basics are that our skin changes its conductivity depending on how we feel.\r\n\r\nWe start by connect our Arduino to the subject and then connect the Arduino to a computer with the graphing software (I\'ll go over this in detail later)\r\n\r\nWe have to start by asking the subject some easy questions we know they will answer truthfully like \'\'what is your name\'\' and \'\'where do you live\'\' to get a baseline and from there we can start asking questions that they may lie about, if they do they would probably feel nervous and then we can read the change in the base line that be established earlier if they lie :D<br><br>\r\n\r\nWe are going to need a microcontroller to control the three LEDs and send the computer the data. In order for the computer receive the data from the microcontroller the microcontroller has to have a serial communication chip this means we can\'t use the Arduino pro mini or Adafruit trinket so when picking your microcontroller make sure it has a serial communication chip built in (USB communication chip)<br><br>\r\nThe main piece of software we are going use is the newest version on the Arduino IDE. The new update brings a new way to see the data being received from the Arduino, instead of being in text form from the serial monitor, it can now be displayed in a real time graph which will help us identify when the data changes its pattern (when someone lies)\r\n\r\nTo open the plotter open Arduino and navigate to the tools menu and you should see it there just below serial monitor.\r\n\r\nNow the code for the micro controller download the attached file, open it and upload it to your board<br><br>\r\nNow that the basic form of the project is done we can start adding features to make it easier to use we will start by adding finger clips to keep a stable connection between our fingers and the cables. Lets start by gluing a strip of tinfoil to the bottom of a strip of velcro, do this for both pieces of velcro (the hook and the loop. Now rap it around your finger until it makes a tight fit (check photos) then tape the exposed wire from analog pin 0 to the tin foil and repeat this step for the 5 volt pin (make sure it makes a good connection)<br><br>\r\n\r\nhe plan is to make a small compartment for the finger pads to fold away and to have three holes for the leds to stick out. Its going to be made out of cardboard and to make it we will need to cut the following shapes out:<br>\r\n<ul>\r\n<li>Cut two 15x3 cm rectangles</li>\r\n<li>One 15x5 cm rectangle</li>\r\n<li>Three 5x3 cm rectangles (cut a square in the middle on one of them for the nanos usb)</li>\r\n<li>One 9x5 cm rectangle</li>\r\n<li>One 6x5 cm rectangle</li></ul>\r\nThe 15x5 rectangle is the base. The two 15x3 rectangles and two of the 5x3 rectangles get glued to the sides of the base. Now glue the third 5x3 rectangle to the base 6cm from the side (close to the middle, check photos) Now you should have a rectangle thats divided into two sides, one with a length of 6cm and the other with a length of 9cm. The side with a length of 6cm is where we are going to put the electronics and the other side is where the finger pads go. Next cut 3 holes (the size of leds) on the 6x5 rectangle and glue it down to the 6cm side (as a lid). Last we need to tape the short side of the 9x5 rectangle to the far side of the 9cm side (this acts as a lid that flips up and down to reveal the finger pads)<br><br>\r\nThe last thing we need to do is put the electronics in the case start by gluing down the arduino and all wires in the 6cm side and run the extended wires(pin analog 0 and 5 volt) to the other side of of the rectangle (9cm side). Now glue the three leds to the holes we made on the 6x5cm rectangle and give it a test if all goes well you should have a small portable Arduino lie detector but let me warn you this isnt the most accurate system in fact most real lie detectors use a host of other sensors to determine if someone is lying such as a heart rate monitor and others, what im saying is dont uses the result of this for serious questions. :D\r\n\r\nIf you have any questions please either send me a personal message or leave a comment and ill try my best to get back to you.<br><br>\r\nfor more info click <a href=\'https://www.instructables.com/id/Arduino-Lie-Detector/\'>here</a>', '2019-05-30 00:13:31', '2019-05-30 00:13:31', 'projekt1.jpg'),
(3, 110002, 'Arduino Solar Tracker', 'How it works: I\'d made a sensor of 4 LDRs with sheets between them The white dots are the LDRs When the stick on top is righted to the sun or the brightest point the four LDRs get the same amount of light on them.', '\r\nWhat is does:\r\nIt searches for the brightest light source like the sun.\r\n\r\nThere is a newer and better version of this project <a href=\'https://www.instructables.com/id/Dual-Axis-300W-IOT-Solar-Tracker/\'>here</a>\r\n<iframe width=\'100%\' height=\'100%\' src=\'https://www.youtube.com/embed/aJC_9wlAXz8\' frameborder=\'0\' allow=\'accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\' allowfullscreen></iframe>\r\nHow it works:\r\nI\'d made a sensor of 4 LDRs with sheets between them\r\n\r\nThe white dots are the LDRs\r\n\r\nWhen the stick on top is righted to the sun or the brightest point \r\nthe four LDRs get the same amount of light on them.\r\n\r\nExample1 when the light is left on top:\r\nright-top, right-down, left-down are in the shadow\r\nand left-top get the most light\r\n\r\nExample2 when the light is on top\r\nleft and right down are in the shadow and top is in the light', '2019-05-30 00:27:41', '2019-05-30 00:27:41', 'projekt3.jpg'),
(4, 110003, 'Arduino LED Equalizer', 'I found the 8x8x8 ledcube project really cool but I did not want to blindly copy it because it would not have been new. After thinking a bit I got an idea to build a 3D spectrum analyser that reacts to music and here is the result! It is amazing to play piano with it. HolKann (alias) is a friend of mine who wrote the code for this project. After I built the spectrum analyser I asked him to help me with the programming and he was happy to work on the project! It was a learning experience for both of us', 'First things first though, the microprocessor to be programmed was an 80MHz Olimex PIC32, soldered to the PIC32-PINGUINO-OTG development board. (For those who ever tinkered with Arduino boards: it\'s the same, only with a faster chip and fewer builtin libraries :| ) The Algorithm had to sample the input signal at regular time intervals, convert this signal to the frequency domain, and visualize the detected frequencies on a 16x16x5 LED matrix.<br><br>\r\n<iframe width=\'100%\' height=\'100%\' src=\'https://www.youtube.com/embed/Vn39txtVIHc\' frameborder=\'0\' allow=\'accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\' allowfullscreen></iframe><br>\r\n\r\nOf course, before writing any code, we had to figure out how to convert input samples to a frequency distribution. This thing is done all the time in signal processing by applying the Discrete Fourier Transform (DFT) to the input signal. Given a signal sampled at a constant frequency, a DFT outputs a set of amplitudes of frequency bands residing in the signal. For example, when your signal mainly consists of the middle C (or Do) tone, a DFT will assign a relatively high amplitude to the frequency band encompassing the corresponding 262 Hz frequency.<br><br>\r\n\r\nHowever, the human ear perceives sound logarithmically, meaning that a doubling of the frequency of a sound signal is perceived only as a linearly higher tone. In order to compensate for this, we used the Constant Q transform (CQT) instead of the DFT. In short, where a DFT returns amplitudes for frequency bands f-2f-3f-4f-etc., a CQT works with frequency bands f-2f-4f-8f-etc.<br><br>\r\n\r\nSo from a theoretical perspective, the algorithm needed for the 3DSA was quite simple: sample the input signal at regular time intervals, apply a CQT calculating amplitudes for 16 frequency bands, and make each of the 16 led columns blink appropriately. Given that the Pinguino development board supported C, we assumed implementing this algorithm wouldn\'t be that hard. However, some challenges always pop up ;)<br><br>\r\n\r\n\r\nFirst obstacle: how do you sample a signal at regular time intervals if you only have one thread? A simple solution would be to take a sample, calculate the CQT and visualization, and let the thread sleep until a certain time period has passed before starting a new sample-calculte-visualize cycle. However, we wanted our sampling rate to be 14 KHz, which on an 80 MHz microprocessor left les than 6k clock cycles between samples to calculate the CQT. This proved insufficient -- in the end we used ~1M clock cycles for each calculate-visualize cycle, so we had to figure out how to take new samples while doing the CQT calculation and LED visualization for old samples.<br><br>\r\n\r\nAfter perusing many a Pinguino forum, the solution arrived in the form of interrupts: a piece of code that has a higher priority to run than other code, and is executed by the processor at designated time intervals. Since the Pinguino devs did not provide a C library for interrupts on the PIC32, we had to manually implement this by setting some processor bits to the right value. Having grown up a Java programmer, I could almost feel the silicon under our code :D<br><br>\r\n\r\n\r\nFloating points are slow (without hardware support)\r\nThe other large obstacle turned out to be the non-existing floating point capabilities of the PIC32 chip. Doing any floating point arithmetic in the inner loop of our CQT implementation slowed down the code by an order of magnitude, turning the LED visualization in a slideshow (now I know how an old GPU must feel :p ). In order to remedy this, we resorted to an improvised fixed-point number format, using 10 fractional bits. It complicated multiplication a bit, but got the job done.<br><br>\r\n\r\nOn a related note, at the heart of a CQT lie a sine and cosine calculation, for which the builtin functions also were way too slow. The fix was to implement our own third order Taylor expansion approximation for the sine function, based on an excellent blog of Jasper Vijn. Coincidentally, he also used fixed-point arithmetic, so that was a natural fit.\r\nSeeing our hand-written bit optimizations speed up our algorithm by a factor 10 was ofcourse quite satisfying :)<br><br>\r\n\r\n\r\nIn the end, our code could sample the input signal at 14 kHz, calculate frequency amplitudes in the range of 20 - 7000 Hz, and get a refresh rate of 80 FPS on the PIC32 chip, meaning each CQT-visualization loop took only about 12 ms. It definitely was an instructive hobby project, would program again <br><br>', '2019-05-30 00:41:12', '2019-05-30 00:41:12', 'arduino_eq.jpg');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `basket`
--

CREATE TABLE `basket` (
  `basket_id` bigint(20) NOT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL,
  `completed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `basket`
--

INSERT INTO `basket` (`basket_id`, `product_id`, `quantity`, `created_at`, `completed_at`) VALUES
(10000001, 2, 2, '2019-05-29 16:06:02', '2019-05-30 16:06:02'),
(10000001, 1, 1, '2019-05-29 16:06:47', '2019-05-30 16:06:47'),
(10000002, 5, 1, '2019-05-29 16:06:47', '2019-05-30 16:06:47'),
(10000003, 1, 1, '2019-05-29 20:39:34', NULL),
(10000003, 2, 1, '2019-05-29 20:39:34', NULL),
(10000004, 6, 1, '2019-05-29 20:46:36', NULL),
(10000004, 2, 1, '2019-05-29 20:46:36', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `couriers`
--

CREATE TABLE `couriers` (
  `kurier_id` bigint(20) NOT NULL,
  `description` varchar(16) COLLATE utf8mb4_polish_ci NOT NULL,
  `logo` varchar(64) COLLATE utf8mb4_polish_ci NOT NULL,
  `price` float NOT NULL,
  `connector` varchar(128) COLLATE utf8mb4_polish_ci DEFAULT NULL,
  `gift_volume` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `couriers`
--

INSERT INTO `couriers` (`kurier_id`, `description`, `logo`, `price`, `connector`, `gift_volume`) VALUES
(1, 'Odbiór w punkcie', 'logo_big.png', 0, NULL, NULL),
(2, 'Pocztex24', 'pocztex.png', 12, NULL, NULL),
(3, 'Paczkomaty', 'paczkomaty.jpg', 10, NULL, NULL),
(4, 'DHL', 'dhl.png', 18, NULL, NULL),
(5, 'GLS', 'gls.jpg', 17, NULL, NULL),
(6, 'Kurier Inpost', 'kurier_inpost.png', 12, NULL, NULL),
(7, 'DPD', 'dpd.png', 20, NULL, NULL),
(8, 'FedEx', 'fedex.png', 16, NULL, NULL),
(9, 'List polecony', 'envelo.png', 10, NULL, NULL),
(10, 'List ekonomiczny', 'poczta.jpg', 8, NULL, NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `gen_passwd_log`
--

CREATE TABLE `gen_passwd_log` (
  `id` bigint(20) NOT NULL,
  `email` varchar(64) COLLATE utf8mb4_polish_ci NOT NULL,
  `passwd` varchar(255) COLLATE utf8mb4_polish_ci NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `gen_passwd_log`
--

INSERT INTO `gen_passwd_log` (`id`, `email`, `passwd`, `created_at`) VALUES
(1, 'kzamorski@poczta.pl', 'ZnR9msulsV', '2019-05-22 19:04:01'),
(2, 'kzamorski@poczta.pl', '0', '2019-05-25 22:11:04'),
(3, 'kzamorski@poczta.pl', 'tfOXk7XfX6', '2019-05-25 22:12:03'),
(4, 'kzamorski@poczta.pl', 'D2vFxashVx', '2019-05-27 20:29:36'),
(5, 'kzamorski@poczta.pl', '57773mL1G4', '2019-05-28 18:24:46'),
(6, 'kzamorski@poczta.pl', 'Qdcm3kN*c8', '2019-05-28 20:36:00'),
(7, 'kzamorski@poczta.pl', '&EzN99%*PH', '2019-05-28 20:36:32'),
(8, 'kzamorski@poczta.pl', '&EzN99%*PH', '2019-05-28 20:36:32'),
(9, 'kzamorski@poczta.pl', 'R&NOE#61e8', '2019-05-28 20:37:09');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `manufacture`
--

CREATE TABLE `manufacture` (
  `manufacture_id` bigint(20) NOT NULL,
  `description` varchar(64) COLLATE utf8mb4_polish_ci NOT NULL,
  `nation` varchar(32) COLLATE utf8mb4_polish_ci NOT NULL,
  `desc_file_name` varchar(128) COLLATE utf8mb4_polish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `manufacture`
--

INSERT INTO `manufacture` (`manufacture_id`, `description`, `nation`, `desc_file_name`) VALUES
(1, 'Smart Projects', 'IT', NULL),
(2, 'Raspberry Pi Foundation', 'UK', NULL),
(3, 'Digispark', 'CHN', NULL),
(4, 'Elektronik Fundations', 'PL', NULL),
(5, 'Adafruit', 'USA', NULL),
(6, 'Cytron', 'KRN', NULL),
(7, 'Waveshare', 'USA', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `orders`
--

CREATE TABLE `orders` (
  `order_id` bigint(20) NOT NULL,
  `basket_id` bigint(20) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `order_price_type` bigint(20) DEFAULT NULL,
  `kurier_id` bigint(20) NOT NULL,
  `order_price_sum` float NOT NULL,
  `order_discount` int(11) DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `send_date` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `sended` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `orders`
--

INSERT INTO `orders` (`order_id`, `basket_id`, `user_id`, `order_price_type`, `kurier_id`, `order_price_sum`, `order_discount`, `completed_at`, `send_date`, `created_at`, `sended`) VALUES
(1, 10000001, 5, 1, 2, 438, NULL, '2019-05-28 16:53:23', '2019-05-29', '2019-05-28 16:53:23', 1),
(2, 10000002, 5, 5, 5, 182, NULL, '2019-05-28 16:53:23', '2019-05-29', '2019-05-28 16:53:23', 1),
(3, 10000003, 5, 4, 6, 271.98, NULL, NULL, NULL, '2019-05-29 20:39:34', 0),
(4, 10000004, 5, 5, 8, 335.98, NULL, NULL, NULL, '2019-05-29 20:46:36', 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pay_type`
--

CREATE TABLE `pay_type` (
  `pay_type_id` bigint(20) NOT NULL,
  `description` varchar(32) COLLATE utf8mb4_polish_ci NOT NULL,
  `price` float NOT NULL,
  `connector` varchar(128) COLLATE utf8mb4_polish_ci DEFAULT NULL,
  `transaction_key` varchar(256) COLLATE utf8mb4_polish_ci DEFAULT NULL,
  `before_payment` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `pay_type`
--

INSERT INTO `pay_type` (`pay_type_id`, `description`, `price`, `connector`, `transaction_key`, `before_payment`) VALUES
(1, 'Gotówka przy odbiorze', 2, NULL, NULL, 0),
(2, 'Płatność kartą online', 0, 'platnosc.karta.pl/clientid=707173289713982131', '23ehu32h2bdyu32bd8723e322naihsa91', 1),
(3, 'Przelew', 0, 'przelew-banki.pl/clientid=707173289713982131', '767da7asux711smma90wiq1ij21902', 1),
(4, 'PayPal', 0, 'paypal.com.eu/clientid=707173289713982131', '3424n32dj3n2n3d98asdnau88adsauwhauiauhuq', 1),
(5, 'BLiK', 0, 'platnosc-blin.pl/clientid=707173289713982131', 'ahudhaq78y121we1198??@*(#USW', 1),
(6, 'Przelew24', 3, 'przelew24.pl/clientid=707173289713982131', '81931n2ui1s7a66tawbd8a7wdw', 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `products`
--

CREATE TABLE `products` (
  `product_id` bigint(20) NOT NULL,
  `product_num` int(11) NOT NULL,
  `prod_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL,
  `size` int(11) NOT NULL,
  `price` float NOT NULL,
  `price_old` float DEFAULT NULL,
  `picture` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL,
  `description_short` text CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL,
  `description_long` text CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL,
  `manufacture_id` bigint(20) NOT NULL,
  `quantity` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `warehouse_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Zrzut danych tabeli `products`
--

INSERT INTO `products` (`product_id`, `product_num`, `prod_name`, `size`, `price`, `price_old`, `picture`, `description_short`, `description_long`, `manufacture_id`, `quantity`, `created_at`, `updated_at`, `warehouse_date`) VALUES
(1, 7200001, 'Arduino Uno Rev3', 2, 99.99, NULL, 'arduino-uno-rev3.jpg', 'Oryginalny moduł od Arduino Uno z mikrokontrolerem AVR ATmega328 w wymiennej obudowie. Posiada 32 kB pamięci Flash, 2 kB RAM, 14 cyfrowych wejść/wyjść z czego 6 można wykorzystać jako kanały PWM, 6 wejść analogowych oraz popularne interfejsy komunikacyjne.', '<h4>Opis</h4>\r\nArduino Uno jest podstawową i zarazem najpopularniejszą wersją z całej serii. Płytka zawiera mikrokontroler ATmega328, wyposażony w 14 cyfrowych wejść/wyjść z czego 6 można wykorzystać jako wyjścia PWM (np. do sterowania silnikami) oraz 6 analogowych wejść. Układ taktowany jest sygnałem zegarowym o częstotliwości 16 MHz, posiada 32 kB pamięci programu Flash oraz 2 kB pamięci operacyjnej SRAM.<br><br>\r\n\r\n<H4>Co posiada?</h4>\r\n<table border=\"2\" style=\"padding-bottom:30px\"><tr><td>\r\nDzięki zainstalowanemu bootloaderowi do zaprogramowania urządzenia wystarczy odpowiedni przewód USB oraz oprogramowanie ze strony producenta.</td></tr>\r\n<tr><td>\r\nRozkład złącz umożliwia montaż dedykowanych nakładek tzw. Arduino Shield.</td></tr>\r\n<tr><td>\r\n14 cyfrowych wejść/wyjść umożliwia m.in. sterowanie diodami LED, przekaźnikami oraz odczytywanie stanów przycisków.</td></tr>\r\n<tr><td>\r\nMaksymalna wydajność prądowa pojedynczego wyprowadzenia wynosi 40 mA.</td></tr>\r\n<tr><td>\r\n6 wyjść PWM pozwala np. na sterowanie silnikami oraz regulowanie jasności diod.</td></tr>\r\n<tr><td>\r\n6 wejść wbudowanego przetwornika analogowo-cyfrowego o rozdzielczości 10-bitów obsługuje m.in. czujniki z wyjściem analogowym.</td></tr>\r\n<tr><td>\r\nUrządzenie obsługuje popularne interfejsy komunikacyjne, m.in.: UART, I2C i SPI.</td></tr>\r\n<tr><td>\r\nFunkcje specjalne 	Niektóre piny posiadają funkcje specjalne, których krótki opis dostępny jest w naszym przewodniku.</td></tr>\r\n<tr><td>\r\nUkład Atmega328 taktowany jest sygnałem o częstotliwości 16 MHz, posiada 32 kB pamięci programu Flash, 1 kB EEPROM oraz 2 kB pamięci operacyjnej SRAM.</td></tr>\r\n<tr><td>\r\nDo zasilania Arduino można wykorzystać dowolny zasilacz o napięciu od 7 V do 12 V ze złączem DC 5,5 x 2,1 mm.</td></tr>\r\n<tr><td>\r\nPłytkę można zasilać z komputera poprzez przewód USB pamiętając przy tym, że maksymalna wydajność prądowa portu USB wynosi 500 mA. Arduino posiada system chroniący gniazdo przed zwarciem oraz przepływem zbyt wysokiego prądu.\r\n<tr><td>\r\nModuł posiada wyprowadzenia ICSP służące do podłączenia zewnętrznego programatora AVR.</td></tr>\r\n<tr><td>\r\nPin IOREF umożliwia bezpośredni dostęp do napięcia z jakim pracują wyprowadzenia I/O.</td></tr>\r\n<tr><td>\r\nPodłączona dioda LED na pinie 13 umożliwia debuggowanie prostych programów.</td></tr>\r\n<tr><td>\r\nWbudowany regulator napięcia umożliwia zasilanie zewnętrznych urządzeń napięciem 3,3 V o poborze prądu do 50 mA.</td></tr>\r\n<tr><td>\r\nDzięki zastosowaniu obudowy przewlekanej THT w przypadku uszkodzenia mikrokontrolera głównego Atmega328P można go w prosty sposób wymienić.</td></tr></table>\r\n<br>\r\n<br>\r\n<br>\r\n<h4>Specyfikacja:</h4>\r\n<ul>\r\n<li>Napięcie zasilania: od 7 V do 12 V</li>\r\n<li>Model: Arduino Uno</li>\r\n<li>Mikrokontroler: ATmega328\r\n<ul>\r\n	<li>Maksymalna częstotliwość zegara: 16 MHz</li>\r\n	<li>Pamięć SRAM: 2 kB</li>\r\n	<li>Pamięć Flash: 32 kB (5 kB zarezerwowane dla bootloadera)</li>\r\n	<li>Pamięć EEPROM: 1 kB</li>\r\n</ul></li>\r\n<li>Porty I/O: 14\r\n<li>Wyjścia PWM: 6\r\n<li>Ilość wejść analogowych: 6 (kanały przetwornika A/C o rozdzielczości 10 bitów)\r\n<li>Interfejsy szeregowe: UART, SPI, I2C\r\n<li>Zewnętrzne przerwania\r\n<li>Podłączona dioda LED na pinie 13\r\n<li>Gniazdo USB A do programowania\r\n<li>Złącze DC 5,5 x 2,1 mm do zasilania\r\n<li>W zestawie przezroczyste nóżki samoprzylepne', 1, 9, '2019-05-28 18:57:17', '2019-05-29 20:39:34', NULL),
(2, 7200002, 'Arduino Mega 2560 Rev3', 2, 159.99, 165.99, 'arduino-mega-2560-rev3.jpg', 'Popularny moduł z mikrokontrolerem AVR ATmega2560. Posiada 256 kB pamięci Flash, 8 kB RAM, 54 cyfrowych wejść/wyjść z czego 15 można wykorzystać jako kanały PWM, 16 wejść analogowych oraz popularne interfejsy komunikacyjne.', '<h4>Opis</h4>\r\nArduino Mega jest z jedną z najbogatszych wersji. Płytka zawiera mikrokontroler ATmega2560, wyposażony w 54 cyfrowych wejść/wyjść z czego 15 można wykorzystać jako wyjścia PWM (np. do sterowania silnikami) oraz 16 analogowych wejść. Układ taktowany jest sygnałem zegarowym o częstotliwości 16 MHz, posiada 256 kB pamięci programu Flash oraz 8 kB pamięci operacyjnej SRAM.<br><br>\r\n\r\nPoniżej przedstawiamy kilka cech, które wyróżniają moduły Arduino na tle innych płytek programowalnych.<br>\r\n<ul>\r\n<li>Dzięki zainstalowanemu bootloaderowi do zaprogramowania urządzenia wystarczy odpowiedni przewód USB oraz oprogramowanie ze strony producenta.</li>\r\n<li>Rozkład złącz umożliwia montaż dedykowanych nakładek tzw. Arduino Shield.</li>\r\n<li>56 cyfrowych wejść/wyjść umożliwia m.in. sterowanie diodami LED, przekaźnikami oraz odczytywanie stanów przycisków.</li>\r\n<li>Maksymalna wydajność prądowa pojedynczego wyprowadzenia wynosi 40 mA.</li>\r\n<li>15 wyjść PWM pozwala np.na sterowanie silnikami oraz regulowanie jasności diod.</li>\r\n<li>16 wejść wbudowanego przetwornika analogowo-cyfrowego o rozdzielczości 10-bitów obsługuje m.in. czujniki z wyjściem analogowym.</li>\r\n<li>Urządzenie obsługuje popularne interfejsy komunikacyjne, m.in.: UART, I2C i SPI.</li>\r\n<li>Niektóre piny posiadają funkcje specjalne, których krótki opis dostępny jest w naszym przewodniku.</li>\r\n<li>Układ Atmega2560 taktowany jest sygnałem o częstotliwości 16 MHz, posiada 256 kB pamięci programu Flash, 4 kB EEPROM oraz 8 kB pamięci operacyjnej SRAM.</li>\r\n<li>Do zasilania Arduino można wykorzystać dowolny zasilacz o napięciu od 7 V do 12 V ze złączem DC 5,5 x 2,1 mm.</li>\r\n<li>Płytkę można zasilać z komputera poprzez przewód USB pamiętając przy tym, że maksymalna wydajność prądowa portu USB wynosi 500 mA. Arduino posiada system chroniący gniazdo przed zwarciem oraz przepływem zbyt wysokiego prądu.</li>\r\n<li>Moduł posiada wyprowadzenia ICSP służące do podłączenia zewnętrznego programatora AVR.</li>\r\n<li>Pin IOREF umożliwia bezpośredni dostęp do napięcia z jakim pracują wyprowadzenia I/O.</li>\r\n<li>Podłączona dioda LED na pinie 13 umożliwia debuggowanie prostych programów.</li>\r\n<li>Wbudowany regulator napięcia umożliwia zasilanie zewnętrznych urządzeń napięciem 3,3 V o poborze prądu do 50 mA.</li></ul><br><br>\r\n\r\n\r\n<h4>Specyfikacja</h4>\r\n<ul>\r\n<li>Napięcie zasilania:7 V do 12 V</li>\r\n<li>Mikrokontroler: ATmega 2560\r\n<ul>\r\n<li>Maksymalna częstotliwość zegara: 16 MHz</li>\r\n<li>Pamięć SRAM: 8 kB</li>\r\n<li>Pamięć Flash: 256 kB (8 kB zarezerwowane dla bootloadera)</li>\r\n<li>Pamięć EEPROM: 4 kB</li>\r\n</ul></li>\r\n<li>Piny I/O: 54</li>\r\n<li>Kanały PWM: 15</li>\r\n<li>Ilość wejść analogowych: 16 (kanały przetwornika A/C o rozdzielczości 10 bitów)</li>\r\n<li>Interfejsy szeregowe: 4xUART, SPI, I2C</li>\r\n<li>Zewnętrzne przerwania</li>\r\n<li>Podłączona dioda LED do pinu 13</li>\r\n<li>Gniazdo USB A do programowania</li>\r\n<li>Złącze DC 5,5 x 2,1 mm do zasilania</li></ul>', 1, 11, '2019-05-28 18:57:17', '2019-05-29 20:46:36', NULL),
(3, 7200003, 'Arduino Uno WiFi Rev2', 2, 199.99, NULL, 'arduino-uno-wifi-rev2.jpg', 'Moduł z mikrokontrolerem AVR ATmega4809 wyposażony w układ U-blok W102 do komunikacji z siecią WiFi. Posiada 48 kB pamięci Flash, 6 kB RAM, 14 cyfrowych wejść/wyjść z czego 5 można wykorzystać jako kanały PWM, 6 wejść analogowych oraz popularne interfejsy komunikacyjne.', '<h4>Opis</h4>\r\nPopularna wersja płytki Arduino Uno z wbudowanym mikrokontrolerem AVR ATmega4809 oraz układem U-blok W102  do komunikacji z siecią WiFi. ATmage4809 został wyposażony w 14 cyfrowych wejść/wyjść z czego 5 można wykorzystać jako wyjścia PWM (np. do sterowania silnikami) oraz 6 analogowych wejść. Układ taktowany jest sygnałem zegarowym o częstotliwości 20 MHz, posiada 48 kB pamięci programu Flash, 6 kB pamięci operacyjnej SRAM oraz 256 B pamięci EEPROM. Płytka wyposażona w układ IMU (Inertial Measurement Unit) oraz moduł kryptograficzny ECC608.<br><br>\r\n\r\nPoniżej przedstawiamy kilka cech, które wyróżniają moduły Arduino na tle innych płytek programowalnych.<br>\r\n<ul>\r\n<li>Dzięki zainstalowanemu bootloaderowi do zaprogramowania urządzenia wystarczy odpowiedni przewód USB oraz oprogramowanie ze strony producenta.</li>\r\n<li>Rozkład złącz umożliwia montaż dedykowanych nakładek tzw. Arduino Shield.</li>\r\n<li>14 cyfrowych wejść/wyjść umożliwia m.in. sterowanie diodami LED, przekaźnikami oraz odczytywanie stanów przycisków.</li>\r\n<li>Maksymalna wydajność prądowa pojedynczego wyprowadzenia wynosi 40 mA.</li>\r\n<li>5 wyjść PWM pozwala np.na sterowanie silnikami oraz regulowanie jasności diod.</li>\r\n<li>6 wejść wbudowanego przetwornika analogowo-cyfrowego o rozdzielczości 10-bitów obsługuje m.in. czujniki z wyjściem analogowym.</li>\r\n<li>Urządzenie obsługuje popularne interfejsy komunikacyjne, m.in.: UART, I2C i SPI.</li>\r\n<li>Niektóre piny posiadają funkcje specjalne, których krótki opis dostępny jest w naszym przewodniku.</li>\r\n<li>Układ Atmega2560 taktowany jest sygnałem o częstotliwości 16 MHz, posiada 256 kB pamięci programu Flash, 4 kB EEPROM oraz 8 kB pamięci operacyjnej SRAM.</li>\r\n<li>Do zasilania Arduino można wykorzystać dowolny zasilacz o napięciu od 7 V do 12 V ze złączem DC 5,5 x 2,1 mm.</li>\r\n<li>Płytkę można zasilać z komputera poprzez przewód USB pamiętając przy tym, że maksymalna wydajność prądowa portu USB wynosi 500 mA. Arduino posiada system chroniący gniazdo przed zwarciem oraz przepływem zbyt wysokiego prądu.</li>\r\n<li>Moduł posiada wyprowadzenia ICSP służące do podłączenia zewnętrznego programatora AVR.</li>\r\n<li>Pin IOREF umożliwia bezpośredni dostęp do napięcia z jakim pracują wyprowadzenia I/O.</li>\r\n<li>Podłączona dioda LED na pinie 13 umożliwia debuggowanie prostych programów.</li>\r\n<li>Wbudowany moduł U-blok W102 umożliwia dostęp do WiFi, co pozwala na stworzenie sieci IoT (Internet Rzeczy).</li>\r\n<li>Wbudowany regulator napięcia umożliwia zasilanie zewnętrznych urządzeń napięciem 3,3 V o poborze prądu do 50 mA.</li></ul><br><br>\r\n\r\n\r\n<h4>Specyfikacja</h4>\r\n<ul>\r\n<li>Napięcie zasilania:7 V do 12 V</li>\r\n<li>Mikrokontroler: ATmega 2560\r\n<ul>\r\n<li>Maksymalna częstotliwość zegara: 16 MHz</li>\r\n<li>Pamięć SRAM: 8 kB</li>\r\n<li>Pamięć Flash: 256 kB (8 kB zarezerwowane dla bootloadera)</li>\r\n<li>Pamięć EEPROM: 4 kB</li>\r\n</ul></li>\r\n<li>Moduł WiFi U-blok W102</li>\r\n<li>Piny I/O: 54</li>\r\n<li>Kanały PWM: 15</li>\r\n<li>Ilość wejść analogowych: 16 (kanały przetwornika A/C o rozdzielczości 10 bitów)</li>\r\n<li>Interfejsy szeregowe: 4xUART, SPI, I2C</li>\r\n<li>Zewnętrzne przerwania</li>\r\n<li>Podłączona dioda LED do pinu 13</li>\r\n<li>Gniazdo USB A do programowania</li>\r\n<li>Złącze DC 5,5 x 2,1 mm do zasilania</li></ul>', 1, 8, '2019-05-28 18:57:17', '2019-05-28 18:57:17', NULL),
(4, 7200004, 'Arduino Yun Rev2 ABX00020', 2, 259.99, NULL, 'arduino-yun-rev2.jpg', 'Połączenie Arduino oraz systemu Linux pozwala poprzez sieć WiFi bezprzewodowo programować i sterować urządzeniem. Moduł oparty układzie ATmega32u4, posiada 32 kB pamięci Flash, 2,5 kB RAM, 20 cyfrowych wejść/wyjść z czego 7 można wykorzystać jako kanały PWM i 12 jako analogowe wejścia oraz interfejsy, w tym USB.', '<h4>Opis</h4>\r\nYun to połączenia Arduino Leonardo i kontrolera Atheros AR9331 z obsługą WiFi. Płytka zawiera mikrokontroler ATmega32u4 wyposażony w 20 cyfrowych wejść/wyjść z czego 7 można wykorzystać jako wyjścia PWM (np. do sterowania silnikami) oraz 12 jako wejścia analogowe. Układ taktowany jest sygnałem zegarowym o częstotliwości 16 MHz, posiada 32 kB pamięci programu Flash oraz 2,5 kB pamięci operacyjnej SRAM.<br><br>\r\n\r\n<h4>Co wyróżnia Yun w stosunku do innych?</h4>\r\n<ul>\r\n<li>Znacznie lepszy i bardziej wytrzymały moduł zasilający</li>\r\n<li>Złącze Ethernet zamontowane niżej, co umożliwia wykorzystanie dowolnej nakładki Arduino Shield</li>\r\n<li>Poziome ułożenie złącza USB</li>\r\n<li>Usprawniony hub USB</li>\r\n<li>Zainstalowana najnowsza wersja OpenWRT wraz z poprawkami</li>\r\n<li>Obsługa SSL w komunikacji Arduino - Linux</li></ul><br><br>\r\n\r\nPoniżej przedstawiamy kilka cech, które wyróżniają moduły Arduino na tle innych płytek programowalnych.<br>\r\n<ul>\r\n<li>Dzięki zainstalowanemu bootloaderowi do zaprogramowania urządzenia wystarczy odpowiedni przewód USB oraz oprogramowanie ze strony producenta.</li>\r\n<li>Rozkład złącz umożliwia montaż dedykowanych nakładek tzw. Arduino Shield.</li>\r\n<li>14 cyfrowych wejść/wyjść umożliwia m.in. sterowanie diodami LED, przekaźnikami oraz odczytywanie stanów przycisków.</li>\r\n<li>Maksymalna wydajność prądowa pojedynczego wyprowadzenia wynosi 40 mA.</li>\r\n<li>5 wyjść PWM pozwala np.na sterowanie silnikami oraz regulowanie jasności diod.</li>\r\n<li>6 wejść wbudowanego przetwornika analogowo-cyfrowego o rozdzielczości 10-bitów obsługuje m.in. czujniki z wyjściem analogowym.</li>\r\n<li>Urządzenie obsługuje popularne interfejsy komunikacyjne, m.in.: UART, I2C i SPI.</li>\r\n<li>Niektóre piny posiadają funkcje specjalne, których krótki opis dostępny jest w naszym przewodniku.</li>\r\n<li>Układ Atmega2560 taktowany jest sygnałem o częstotliwości 16 MHz, posiada 256 kB pamięci programu Flash, 4 kB EEPROM oraz 8 kB pamięci operacyjnej SRAM.</li>\r\n<li>Do zasilania Arduino można wykorzystać dowolny zasilacz o napięciu od 7 V do 12 V ze złączem DC 5,5 x 2,1 mm.</li>\r\n<li>Płytkę można zasilać z komputera poprzez przewód USB pamiętając przy tym, że maksymalna wydajność prądowa portu USB wynosi 500 mA. Arduino posiada system chroniący gniazdo przed zwarciem oraz przepływem zbyt wysokiego prądu.</li>\r\n<li>Moduł posiada wyprowadzenia ICSP służące do podłączenia zewnętrznego programatora AVR.</li>\r\n<li>Pin IOREF umożliwia bezpośredni dostęp do napięcia z jakim pracują wyprowadzenia I/O.</li>\r\n<li>Podłączona dioda LED na pinie 13 umożliwia debuggowanie prostych programów.</li>\r\n<li>Wbudowany moduł U-blok W102 umożliwia dostęp do WiFi, co pozwala na stworzenie sieci IoT (Internet Rzeczy).</li>\r\n<li>Wbudowany regulator napięcia umożliwia zasilanie zewnętrznych urządzeń napięciem 3,3 V o poborze prądu do 50 mA.</li></ul><br><br>\r\n\r\n\r\n<h4>Specyfikacja</h4>\r\n<ul>\r\n<li>Napięcie zasilania:7 V do 12 V</li>\r\n<li>Mikrokontroler: ATmega 2560\r\n<ul>\r\n<li>Maksymalna częstotliwość zegara: 16 MHz</li>\r\n<li>Pamięć SRAM: 2,5 kB</li>\r\n<li>Pamięć Flash: 32 kB (4 kB zarezerwowane dla bootloadera)</li>\r\n<li>Pamięć EEPROM: 1 kB</li>\r\n<li>Porty I/O: 20</li>\r\n<li>Wyjścia PWM: 7</li>\r\n<li>Ilość wejść analogowych: 12 (kanały przetwornika A/C o rozdzielczości 10 bitów)</li>\r\n<li>Interfejsy szeregowe: UART, SPI, I2C</li>\r\n<li>Zewnętrzne przerwania</li>\r\n</ul></li>\r\n<li>Moduł WiFi U-blok W102</li>\r\n<li>Procesor Linux: Atheros AR9331\r\n<ul>\r\n<li>Architektura: MIPS 400 MHz</li>\r\n<li>Napięcie zasilania: 3,3 V</li>\r\n<li>Ethernet IEEE 802.3 10/100Mbit/s</li>\r\n<li>WiFi IEEE 802.11b/g/n</li>\r\n<li>Pamięć RAM: 64 MB DDR2</li>\r\n<li>Pamięć Flash: 16 MB</li></ul>\r\n<li>Piny I/O: 54</li>\r\n<li>Kanały PWM: 15</li>\r\n<li>Ilość wejść analogowych: 16 (kanały przetwornika A/C o rozdzielczości 10 bitów)</li>\r\n<li>Interfejsy szeregowe: 4xUART, SPI, I2C</li>\r\n<li>Zewnętrzne przerwania</li>\r\n<li>Podłączona dioda LED do pinu 13</li>\r\n<li>Gniazdo USB A do programowania</li>', 1, 5, '2019-05-28 18:57:17', '2019-05-28 18:57:17', NULL),
(5, 7200005, 'Arduino Yun Mini A000108', 2, 259.99, 269.99, 'arduino-yun-mini.jpg', 'Połączenie Arduino oraz systemu Linux pozwala poprzez sieć WiFi bezprzewodowo programować i sterować urządzeniem. Moduł oparty na układzie ATmega32u4, posiada 32 kB pamięci Flash, 2,5 kB RAM, 20 cyfrowych wejść/wyjść z czego 7 można wykorzystać jako kanały PWM i 12 jako analogowe wejścia oraz interfejsy, w tym USB. Ta wersja charakteryzuje się niewielkimi rozmiarami, bo tylko 28 x 74mm', '<h4>Opis</h4>\r\nYun w wersji mini to połączenia Arduino Leonardo i kontrolera Atheros AR9331 z obsługą WiFi. Płytka zawiera mikrokontroler ATmega32u4 wyposażony w 20 cyfrowych wejść/wyjść z czego 7 można wykorzystać jako wyjścia PWM (np. do sterowania silnikami) oraz 7 jako wejścia analogowe. Układ taktowany jest sygnałem zegarowym o częstotliwości 16 MHz, posiada 32 kB pamięci programu Flash oraz 2,5 kB pamięci operacyjnej SRAM.<br><br>\r\n\r\n<h4>Co wyróżnia Yun w stosunku do innych?</h4>\r\n<ul>\r\n<li>Znacznie lepszy i bardziej wytrzymały moduł zasilający</li>\r\n<li>Złącze Ethernet zamontowane niżej, co umożliwia wykorzystanie dowolnej nakładki Arduino Shield</li>\r\n<li>Poziome ułożenie złącza USB</li>\r\n<li>Usprawniony hub USB</li>\r\n<li>Zainstalowana najnowsza wersja OpenWRT wraz z poprawkami</li>\r\n<li>Obsługa SSL w komunikacji Arduino - Linux</li></ul><br><br>\r\n\r\nPoniżej przedstawiamy kilka cech, które wyróżniają moduły Arduino na tle innych płytek programowalnych.<br>\r\n<ul>\r\n<li>Dzięki zainstalowanemu bootloaderowi do zaprogramowania urządzenia wystarczy odpowiedni przewód USB oraz oprogramowanie ze strony producenta.</li>\r\n<li>Rozkład złącz umożliwia montaż dedykowanych nakładek tzw. Arduino Shield.</li>\r\n<li>14 cyfrowych wejść/wyjść umożliwia m.in. sterowanie diodami LED, przekaźnikami oraz odczytywanie stanów przycisków.</li>\r\n<li>Maksymalna wydajność prądowa pojedynczego wyprowadzenia wynosi 40 mA.</li>\r\n<li>5 wyjść PWM pozwala np.na sterowanie silnikami oraz regulowanie jasności diod.</li>\r\n<li>6 wejść wbudowanego przetwornika analogowo-cyfrowego o rozdzielczości 10-bitów obsługuje m.in. czujniki z wyjściem analogowym.</li>\r\n<li>Urządzenie obsługuje popularne interfejsy komunikacyjne, m.in.: UART, I2C i SPI.</li>\r\n<li>Niektóre piny posiadają funkcje specjalne, których krótki opis dostępny jest w naszym przewodniku.</li>\r\n<li>Układ Atmega2560 taktowany jest sygnałem o częstotliwości 16 MHz, posiada 256 kB pamięci programu Flash, 4 kB EEPROM oraz 8 kB pamięci operacyjnej SRAM.</li>\r\n<li>Do zasilania Arduino można wykorzystać dowolny zasilacz o napięciu od 7 V do 12 V ze złączem DC 5,5 x 2,1 mm.</li>\r\n<li>Płytkę można zasilać z komputera poprzez przewód USB pamiętając przy tym, że maksymalna wydajność prądowa portu USB wynosi 500 mA. Arduino posiada system chroniący gniazdo przed zwarciem oraz przepływem zbyt wysokiego prądu.</li>\r\n<li>Moduł posiada wyprowadzenia ICSP służące do podłączenia zewnętrznego programatora AVR.</li>\r\n<li>Pin IOREF umożliwia bezpośredni dostęp do napięcia z jakim pracują wyprowadzenia I/O.</li>\r\n<li>Podłączona dioda LED na pinie 13 umożliwia debuggowanie prostych programów.</li>\r\n<li>Wbudowany moduł U-blok W102 umożliwia dostęp do WiFi, co pozwala na stworzenie sieci IoT (Internet Rzeczy).</li>\r\n<li>Wbudowany regulator napięcia umożliwia zasilanie zewnętrznych urządzeń napięciem 3,3 V o poborze prądu do 50 mA.</li></ul><br><br>\r\n\r\n\r\n<h4>Specyfikacja</h4>\r\n<ul>\r\n<li>Napięcie zasilania:7 V do 12 V</li>\r\n<li>Niski pobór prądu: do 1A</li>\r\n<li>Mikrokontroler: ATmega 2560\r\n<ul>\r\n<li>Maksymalna częstotliwość zegara: 16 MHz</li>\r\n<li>Pamięć SRAM: 2,5 kB</li>\r\n<li>Pamięć Flash: 32 kB (4 kB zarezerwowane dla bootloadera)</li>\r\n<li>Pamięć EEPROM: 1 kB</li>\r\n<li>Porty I/O: 20</li>\r\n<li>Wyjścia PWM: 7</li>\r\n<li>Ilość wejść analogowych: 12 (kanały przetwornika A/C o rozdzielczości 10 bitów)</li>\r\n<li>Interfejsy szeregowe: UART, SPI, I2C</li>\r\n<li>Zewnętrzne przerwania</li>\r\n</ul></li>\r\n<li>Moduł WiFi U-blok W102</li>\r\n<li>Procesor Linux: Atheros AR9331\r\n<ul>\r\n<li>Architektura: MIPS 400 MHz</li>\r\n<li>Napięcie zasilania: 3,3 V</li>\r\n<li>Ethernet IEEE 802.3 10/100Mbit/s</li>\r\n<li>WiFi IEEE 802.11b/g/n</li>\r\n<li>Pamięć RAM: 64 MB DDR2</li>\r\n<li>Pamięć Flash: 16 MB</li></ul>\r\n<li>Piny I/O: 54</li>\r\n<li>Kanały PWM: 15</li>\r\n<li>Ilość wejść analogowych: 16 (kanały przetwornika A/C o rozdzielczości 10 bitów)</li>\r\n<li>Interfejsy szeregowe: 4xUART, SPI, I2C</li>\r\n<li>Zewnętrzne przerwania</li>\r\n<li>Podłączona dioda LED do pinu 13</li>\r\n<li>Gniazdo USB A do programowania</li>\r\n<li>Gniazdo microUSB</li>\r\n<li>Wymiary płytki: 72 x 23 mm</li>\r\n<li>Masa: 16 g</li></ul>', 1, 14, '2019-05-28 18:57:17', '2019-05-28 18:57:17', NULL),
(6, 7200006, 'Raspberry Pi 3 model B', 2, 159.99, 169.99, 'raspberry-pi-3-model-b.jpg', 'Nowa odsłona popularnego minikomputera Raspberry Pi w wersji 3. Ten model wyróżnia bardziej wydajny procesor Broadcom BCM2837 quad-core 64-bitowy ARM-8 Cortex-A53 1,2 GHz. Ponadto płytka posiada 1 GB pamięci RAM, wbudowany moduł WiFi i Bluetooth 4.1 oraz cztery gniazda USB, 40 GPIO, złącza na kartę microSD, port Ethernet i cztery otwory montażowe.', '<h4>Opis</h4>\r\nNajnowsza odsłona popularnego minikomputera Raspberry Pi w wersji 3 B+. Ten model wyróżnia bardziej wydajny procesor Broadcom BCM2837B0 quad-core 64-bitowy ARM-8 Cortex-A53 1,4 GHz. Ponadto płytka posiada dwuzakresowe WiFi 2,4 GHz i 5 GHz, Bluetooth 4,2 / BLE, port Gigabit Ethernet o prędkości do 300 Mb/s oraz możliwość zasilania przez PoE. Reszta specyfikacji jest identyczna jak model 3 B, czyli cztery gniazda USB, 40 GPIO, złącza na kartę microSD, złącze DSI i CSI i cztery otwory montażowe.<br><br>\r\n\r\n<h4>Co nowego w wersji 2 v1.1?</h4>\r\n<ul>\r\n<li>Chipset Broadcom BCM2837B0 z 64-bitowym rdzeniem Quad-core ARM-8 Cortex-A53 CPU, taktowany 1,4 GHz zapewnia więcej mocy obliczeniowej niż poprzednie modele Raspberry Pi</li>\r\n<li>Nowy, wbudowany moduł WiFi Dual Band 802.11 b/g/n/ac działa w zakresie 2,4 GHz i 5 GHz. Co zapewnia wyższą prędkość transmisji.</li>\r\n<li>Możliwość zasilania przez sieć Ethernet za pomocą dodatkowej nakładki - nakładka typu HAT będzie dostępna wkrótce.</li>\r\n<li>Rozkład elementów oraz obrys płytki pozostały bez zmian. Oznacza to, że obudowy i akcesoria dla wersji Pi 3 będą kompatybilne z Raspberry Pi 3+.</li></ul><br><br>\r\n\r\n<h4>Obraz i dźwięk</h4>\r\nRaspberry Pi posiada złącze HDMI wersji 1.4, poprzez które można przesyłać zarówno obraz jak i dźwięk. Dodatkowo płytka została wyposażana w 4-polowe gniazdo jack 3,5 mm, do którego można podłączyć słuchawki, głośniki lub wyprowadzić wideo poprzez standard RCA Composite. Urządzenie obsługuje kompresję H.264 (1080p30) oraz grafikę OpenGL ES 1.1 i 2.0.<br><br>\r\n\r\n<h4>System operacyjny</h4>\r\nDyskiem maliny jest karta pamięci microSD. System operacyjny można wgrać korzystając z komputera z czytnikiem. W naszym sklepie dostępne są karty z zainstalowanym programem NOOBs, który przy pierwszym uruchomieniu umożliwia wybór spośród systemów: Raspbian, Openelec, RaspBMC, OSMC Linux. Użytkownik może również we własnym zakresie zainstalować system Windows 10 IoT.<br><br>\r\n \r\n<h4>Komunikacja</h4>\r\nMalina posiada podstawowe interfejsy komunikacyjne, które spotkać można w komputerach biurowych klasy PC. Oprócz wcześniej wymienionych złącz audio i wideo użytkownik ma do dyspozycji: \r\n<ul>\r\n<li>cztery złącza USB, pod które można podłączyć np. myszkę, klawiaturę, kartę WiFi czy pendrive. Jeśli okaże się, że gniazd jest zbyt mało można zwiększyć ich ilości stosując zewnętrzny HUB USB.</li>\r\n<li>gniazdo Ethernet, czyli możliwość bezpośredniego podłączenia do sieci LAN</li>\r\n<li>moduł WiFi - pozwala na komunikację z siecią bezprzewodową 2,4 GHz i 5 GHz 802.11b/g/n/ac - najnowszy system Raspbian / NOOBs posiada wbudowane sterowniki</li>\r\n<li>moduł Bluetooth 4.2 - umożliwia przesył danych za pośrednictwem popularnego interfejsu</li>\r\n<li>GPIO - wyjścia/wejścia ogólnego przeznaczenia, które mogą służyć do obsługi diod LED, przycisków, sterowników silników. Wśród nich znajdują się piny obsługujące interfejsy: I2C, SPI i UART. </li></ul><br><br>\r\n\r\n<h4>Zasilanie</h4>\r\nJako źródło zasilania układ wykorzystuje złącze microUSB. Producent zaleca aby napięcie podane na złącze miało wartość 5 V, natomiast wydajność prądowa wykorzystanego zasilacza powinna wynosić co najmniej 2,5 A. W naszej ofercie dostępne są dedykowane zasilacze.<br><br>', 2, 14, '2019-05-28 19:03:56', '2019-05-29 20:46:36', NULL),
(7, 7200007, 'Raspberry Pi 2 model B rev 1.1', 2, 175.99, NULL, 'raspberry-pi-2-model-b.jpg', 'Popularny minikomputer Raspberry Pi 2 w wersji v1.1. Ten model wyróżnia procesor quad-core ARM Cortex-A7 900 MHz i większa ilość pamięci 1 GB RAM. Płytkę wyposażono w znane z wersji B+ peryferia, są to m.in. cztery gniazda USB, dodatkowe 40 GPIO, złącza na kartę microSD, port Ethernet oraz cztery otwory montażowe. ', '<h4>Opis</h4>\r\nNowa odsłona popularnego minikomputera Raspberry Pi 2 w wersji v1.1. Model 2 wyróżnia procesor quad-core ARM Cortex-A7 900 MHz i większa ilość pamięci 1 GB RAM. Płytkę wyposażono w znane z wersji B+ peryferia, są to m.in. cztery gniazda USB, dodatkowe 40 GPIO, złącza na kartę microSD, port Ethernet oraz cztery otwory montażowe.<br><br>\r\n\r\n<h4>Co nowego w wersji 2 v1.1?</h4>\r\n<ul>\r\n<li>Procesor quad-core ARM Cortex-A7 CPU, taktowany częstotliwością 900 MHz</li>\r\n<li>1 GB LPDDR2 SDRAM zamiast 512 MB B+</li>\r\n<li>Układ peryferiów pozostał bez zmian, tak aby zachować kompatybilność z poprzednią wersją<,li></ul><br><br>\r\n\r\n<h4>Obraz i dźwięk</h4>\r\nRaspberry Pi posiada złącze HDMI wersji 1.4, poprzez które można przesyłać zarówno obraz jak i dźwięk. Dodatkowo płytka została wyposażana w 4-polowe gniazdo jack 3,5 mm, do którego można podłączyć słuchawki, głośniki lub wyprowadzić wideo poprzez standard RCA Composite. W naszej ofercie znajdziesz odpowiedni przewód Jack - RCA.<br><br>\r\n\r\n<h4>System operacyjny</h4>\r\nDyskiem maliny jest karta pamięci microSD. System operacyjny można wgrać korzystając z komputera z czytnikiem. W naszym sklepie dostępne są karty z zainstalowanym programem NOOBs, który przy pierwszym uruchomieniu umożliwia wybór spośród systemów: Raspbian, Pidora Openelec, RaspBMC, RISC OS, Aarch Linux. Microsoft obiecuje w przyszłości wydanie Windows 10, który będzie pracował z Raspberry Pi 2.<br><br>\r\n \r\n<h4>Komunikacja</h4>\r\nMalina posiada podstawowe interfejsy komunikacyjne, które spotkać można w komputerach biurowych klasy PC. Oprócz wcześniej wymienionych złącz audio i wideo użytkownik ma do dyspozycji: \r\n<ul>\r\n<li>cztery złącza USB, pod które można podłączyć np. myszkę, klawiaturę, kartę WiFi czy pendrive. Jeśli okaże się, że gniazd jest zbyt mało można zwiększyć ich ilości stosując zewnętrzny HUB USB.</li>\r\n<li>gniazdo Ethernet, czyli możliwość bezpośredniego podłączenia do sieci LAN</li>\r\n<li>GPIO - wyjścia/wejścia ogólnego przeznaczenia, które mogą służyć do obsługi diod LED, przycisków, sterowników silników. Wśród nich znajdują się piny obsługujące interfejsy: I2C, SPI i UART. Od wersji B+ liczba GPIO została zwiększona z 26 do 40.</li><br><br>\r\n\r\n<h4>Zasilanie</h4>\r\nJako źródło zasilania układ wykorzystuje złącze microUSB. W praktyce oznacza to, że do uruchomienia Rasbperry Pi można wykorzystać ładowarkę do telefonów komórkowych o wydajności co najmniej 1 A.<br><br>', 2, 0, '2019-05-28 19:03:56', '2019-05-28 19:03:56', '2019-06-04 00:00:00'),
(8, 7200008, 'Raspberry Pi 2 model B rev 1.2', 2, 179.99, NULL, 'raspberry-pi-2-model-b.jpg', 'Popularny minikomputer Raspberry Pi 2 w wersji v1.2. Ten model wyróżnia procesor quad-core ARM Cortex-A7 900 MHz i większa ilość pamięci 1 GB RAM. Płytkę wyposażono w znane z wersji B+ peryferia, są to m.in. cztery gniazda USB, dodatkowe 40 GPIO, złącza na kartę microSD, port Ethernet oraz cztery otwory montażowe. ', '<h4>Opis</h4>\r\nNowa odsłona popularnego minikomputera Raspberry Pi w wersji 2. Model 2 wyróżnia bardziej wydajny procesor quad-core ARM Cortex-A53 900 MHz i większa ilość pamięci 1 GB RAM. Płytkę wyposażono w znane z wersji B+ peryferia, są to m.in. cztery gniazda USB, dodatkowe 40 GPIO, złącza na kartę microSD, port Ethernet oraz cztery otwory montażowe.<br><br>\r\n\r\n<h4>Co nowego w wersji 2 v1.1?</h4>\r\n<ul>\r\n<li>Procesor quad-core ARM Cortex-A53 CPU, taktowany częstotliwością 900 MHz</li>\r\n<li>1 GB LPDDR2 SDRAM zamiast 512 MB B+</li>\r\n<li>Układ peryferiów pozostał bez zmian, tak aby zachować kompatybilność z poprzednią wersją</li></ul><br><br>\r\n\r\n<h4>Obraz i dźwięk</h4>\r\nRaspberry Pi posiada złącze HDMI wersji 1.4, poprzez które można przesyłać zarówno obraz jak i dźwięk. Dodatkowo płytka została wyposażana w 4-polowe gniazdo jack 3,5 mm, do którego można podłączyć słuchawki, głośniki lub wyprowadzić wideo poprzez standard RCA Composite. W naszej ofercie znajdziesz odpowiedni przewód Jack - RCA.<br><br>\r\n\r\n<h4>System operacyjny</h4>\r\nDyskiem maliny jest karta pamięci microSD. System operacyjny można wgrać korzystając z komputera z czytnikiem. W naszym sklepie dostępne są karty z zainstalowanym programem NOOBs, który przy pierwszym uruchomieniu umożliwia wybór spośród systemów: Raspbian, Pidora Openelec, RaspBMC, RISC OS, Aarch Linux. Microsoft obiecuje w przyszłości wydanie Windows 10, który będzie pracował z Raspberry Pi 2.<br><br>\r\n \r\n<h4>Komunikacja</h4>\r\nMalina posiada podstawowe interfejsy komunikacyjne, które spotkać można w komputerach biurowych klasy PC. Oprócz wcześniej wymienionych złącz audio i wideo użytkownik ma do dyspozycji: \r\n<ul>\r\n<li>cztery złącza USB, pod które można podłączyć np. myszkę, klawiaturę, kartę WiFi czy pendrive. Jeśli okaże się, że gniazd jest zbyt mało można zwiększyć ich ilości stosując zewnętrzny HUB USB.</li>\r\n<li>gniazdo Ethernet, czyli możliwość bezpośredniego podłączenia do sieci LAN</li>\r\n<li>GPIO - wyjścia/wejścia ogólnego przeznaczenia, które mogą służyć do obsługi diod LED, przycisków, sterowników silników. Wśród nich znajdują się piny obsługujące interfejsy: I2C, SPI i UART. Od wersji B+ liczba GPIO została zwiększona z 26 do 40.</li><br><br>\r\n\r\n<h4>Zasilanie</h4>\r\nJako źródło zasilania układ wykorzystuje złącze microUSB. W praktyce oznacza to, że do uruchomienia Rasbperry Pi można wykorzystać ładowarkę do telefonów komórkowych o wydajności co najmniej 1 A.<br><br>', 2, 3, '2019-05-28 19:03:56', '2019-05-28 19:03:56', NULL),
(9, 7200009, 'Ekran dotykowy 7\" DSI do Raspberry Pi', 5, 339.99, 349.99, 'ekran-do-raspberry-pi.jpg', 'Oficjalny ekran dotykowy pojemnościowy 7\" dla Raspberry Pi o rozdzielczości 800 x 480 px. Współpracuje z Raspberry Pi w wersji 3B+, 3B+ 2B, 1B+ poprzez dedykowane złącze DSI. Najnowszy system Raspbian posiada wbudowane sterowniki do tego urządzenia.', '<h4>Opis</h4> Oficjalny ekran dotykowy pojemnościowy 7\" dla Raspberry Pi o rozdzielczości 800 x 480 px. Współpracuje z Raspberry Pi w wersji 3B+, 3B+ 2B, 1B+ poprzez dedykowane złącze DSI. Dzięki dopasowanym otworom wraz ze śrubkami montażowymi, minikomputer można przymocować w tylnej, niewidocznej części ekranu.<br><br> <h4>Podłączenie</h4> Urządzenie należy połączyć ze sterownikiem i Raspberry Pi za pomocą dedykowanej taśmy. Zasilanie do sterownika ekranu można doprowadzić korzystając z przewodów połączeniowych, które znajdują się w zestawie. Najnowszy system Raspbian posiada zainstalowane sterowniki dla ekranu, dlatego też w celu uruchomienia urządzania wystarczy podłączyć taśmę do złącza DSI.  W celu uruchomienia ekranu na dotychczasowej wersji systemu, należy go zaktualizować poprzez polecenie: <ul> <li>‘sudo apt-get update’</li> <li>‘sudo apt-get upgrade’</li> <li>‘sudo rpi-update’</li></ul><br><br>  <h4>Specyfikacja</h4> <li>Typ: ekran dotykowy, pojemnościowy</li> <li>Przekątna: 7\"</li> <li>Rozdzielczość: 800 x 480 px</li> <li>Odświeżanie: 60 fps</li> <li>Głębia kolorów: 24 bity</li> <li>Kąt widzenia: 70 stopni</li> <li>Otwory montażowe do przymocowania minikomputera Raspberry Pi</li> <li>Współpracuje z: Raspberry Pi w wersji 3B+, 3B+ 2B, 1B+</li> <li>Komunikacja poprzez port DSI</li> <li>Najnowszy system Raspbian posiada zainstalowane sterowniki</li> <li>4 otwory montażowe (śrubki znajdują się w zestawie)</li> <li>Wymiary ekranu: 155 x 86 mm</li> <li>Wymiary płytki: 194 x 110 x 20 mm</li></ul>', 2, 10, '2019-05-29 21:12:07', '2019-05-29 21:12:07', NULL),
(10, 7200010, 'Ekran dotykowy Waveshare C - LCD 7\"', 5, 234.99, 249.99, 'ekran-dotykowy-waveshare.jpg', 'Ekran dotykowy Waveshare, pojemnościowy 7 \" dla Raspberry Pi o rozdzielczości 1024 x 600 px. Współpracuje z Raspberry Pi w wersji 3B+, 3B+ 2B, 1B+, 1B, 1A oraz Zero i Zero W poprzez złącze HDMI i przewód USB.', '<h4>Opis</h4> Ekran dotykowy, pojemnościowy 7\" dla Raspberry Pi o rozdzielczości 1024 x 600 px. Współpracuje z  Rasbperry Pi w wersji 3B+, 3B 2B i B+ poprzez złącze HDMI i microUSB - odpowiednie przewody znajdują się w zestawie. Urządzenie współpracuje także z minikomputerami: Banana Pi i Beagle Bone Black.<br><br> <h4>Podłączenie</h4> W celu uruchomienia ekranu należy połączyć urządzenie z Raspberry Pi poprzez dołączone do zestawu przewody: HDMI i microUSB. Złącze HDMI przekazuje obraz, port USB odbiera dane interfejsu dotykowego.<br><br>  <h4>Oprogramowanie</h4> Ekran działa z najnowszym systemem Raspbian bez potrzeby instalacji sterowników. Aby jednak ekran wyświetlał obraz prawidłowo  należy zmienić rozdzielczość w pliku konfiguracyjnym. W tym celu należy otworzyć plik config.txt poleceniem:<br> <i> sudo nano /boot/config.txt</i> <br> a następnie na jego końcu dodać następujące instrukcje:<br>  <i> max_usb_current=1<br> hdmi_group=2<br> hdmi_mode=87<br> hdmi_cvt 1024 600 60 6 0 0 0<br> hdmi_drive=1<br></i>    Po zapisaniu pliku i restarcie maliny obraz i funkcja dotyku powinny działać prawidłowo.   <h4>Specyfikacja</h4> <ul> <li>Typ: ekran dotykowy IPS, pojemnościowy</li> <li>Przekątna: 7\"</li> <li>Rozdzielczość: 1024 x 600 px</li> <li>Standardowy protokół HID integrujący się z systemem</li> <li>Współpracuje z: <ul> <li>Rasbperry Pi w wersji 3B+, 3B 2B i B+ Zero (działa bezpośrednio z systemem od producenta)</li> <li>Beagle Bone Black</li> <li>Banana Pi / Banana Pro</li></ul></li> <li>Wyświetlacz działa również z komputerem PC z systemem Windows 7/8/8.1/10 bez konieczności instalacji sterowników</li> <li>Pracuje też ze wszystkimi innymi urządzeniami HDMI (funkcja dotykowa nie jest wtedy dostępna)</li> <li>4 otwory montażowe (śrubki znajdują się w zestawie)</li> <li>Wymiary ekranu: 165 x 107 mm</li>', 7, 10, '2019-05-29 21:12:07', '2019-05-29 21:12:07', NULL),
(11, 7200011, 'Adafruit NeoPixel Shield 5x8 RGB', 2, 169.99, NULL, 'adafruit-neopixel-shield.jpg', 'Matryca w postaci nakładki na Arduino składa się z 40 indywidualnie adresowanych diod LED RGB rozmieszczonych w postaci 5 wierszy i 8 kolumn. Do obsługi modułu wystarczy jeden pin mikrokontrolera, domyślnie D6.', '<h4>Opis</h4> Matryca w postaci nakładki na Arduino złożona z 40 diod LED RGB, z których każdą można sterować osobno. Elementy rozłożone są równomiernie w pięciu wierszach i ośmiu kolumnach. Do obsługi modułu wystarczy tylko jeden pin Arduino, domyślnie jest to wyprowadzenie numer 6. W zestawie znajdują się złącza goldpin do samodzielnego lutowania. Płytka może być zasilana zarówno z pinu 5V Arduino jak i  z osobnego źródła o napięciu od 4 do 6 V. Dzięki zastosowaniu tranzystora FET moduł posiada ochronę przed odwrotnym podłączeniem zasilania.<br><br> Zastosowany protokół komunikacyjny umożliwia łączenie szeregowe matryc. Kolejny NeoMatrix należy podpiąć do złącza wyjściowego, łącząc ze sobą odpowiednio 5V, GND oraz DOUT z DIN. Producent zaznacza, że przy korzystaniu z czterech lub więcej matryc, może nie wystarczyć pamięci RAM w układzie Arduino Uno. Należy również zwrócić uwagę, że każda kolejna matryca będzie wymagała zwiększenia wydajności źródła zasilania.<br><br>  <h4>Specyfikacja</h4> <ul> <li>Napięcie zasilania do wyboru: <ul> <li>5 V pobierane z Arduino </li> <li>od 4 V do 6 V z zewnętrznego źródła</li> </ul></li> <li>astosowane diody: LED RGB WS2812B</li> <li>Wyprowadzony przycisk RESET Arduino</li> <li>W zestawie znajdują się złącza do samodzielnego lutowania</li> <li>Wymiary: 54 x 69 x 3,3 mm</li> <li>Masa: 28 g</li></ul>', 5, 15, '2019-05-29 21:12:07', '2019-05-29 21:12:07', NULL),
(12, 7200012, 'Adafruit Servo Motor Shield', 3, 99.99, NULL, 'adafruit-servo-motor-shield.jpg', 'Nakładka do Arduino umożliwiająca sterowanie czterema silnikami prądu stałego (13,5V/1,2A), dwoma silnikami krokowymi oraz dwoma serwomechanizmami. Komunikuje się poprzez interfejs I2, wykorzystując tylko dwie linie Arduino.', 'Do tego przedmiotu nie znaleziono opisu', 5, 13, '2019-05-29 21:12:07', '2019-05-29 21:12:07', NULL),
(13, 7200013, 'Cytron SHIELD-2AMOTOR', 2, 44.99, 49.99, 'cytron-shield-2amotor.jpg', 'Nakładka dla Arduino z dwukanałowym sterownikiem silników DC pracujących z napięciem od 5 V do 26 V i prądem do 2 A, oparty o układ L298P. Na płytce znajdują się zworki do wyboru trybu kontroli oraz złącze listwy z czujnikami odbiciowymi LSS05.', '<h4>Opis</h4> Nakładka dla Arduino z dwukanałowym sterownikiem silników DC pracujących z napięciem od 5 V do 26 V i prądem do 2 A, oparty o układ L298P. Na płytce znajdują się zworki do wyboru trybu kontroli oraz złącze listwy z czujnikami odbiciowymi LSS05.<br><br>  <h4>Specyfikacja</h4> <ul> <li>Układ sterownika: L298P</li> <li>Napięcie zasilania: od 5 V do 26 V</li> <li>Maksymalny prąd na kanał: 2 A</li> <li>Napięcie poziomów logicznych: 3,3 V i 5 V</li> <li>Zabezpieczenie przed odwrotną polaryzacją </li> <li>Złącze listwy z czujnikami odbiciowymi LSS05</li> <li>Maksymalna częstotliwość PWM: 10 KHz</li> <li>Wymiary: 68 55 mm</li></ul>', 6, 18, '2019-05-29 21:12:07', '2019-05-29 21:12:07', NULL),
(14, 7200014, 'Waveshare Music Shield VS1053B', 2, 69.99, NULL, 'waveshare-music-shield-vs1053b.jpg', 'Nakładka dla Arduino pozwalająca nagrywać i odtwarzać dźwięk. Posiada wbudowany dekoder VS1053B, slot kart microSD, mikrofon, joystick nawigacyjny oraz złącze słuchawkowe. Wspiera najpopularniejsze formaty dźwięku: MP3, AAC, WMA, WAV, MIDI', '<h4>Opis</h4> Nakładka dla Arduino pozwalająca nagrywać i odtwarzać dźwięk. Posiada wbudowany dekoder VS1053B, slot kart microSD, mikrofon, joystick nawigacyjny oraz złącze słuchawkowe. Wspiera najpopularniejsze formaty dźwięku: MP3, AAC, WMA, WAV, MIDI. Urządzenie pozwala stworzyć zaawansowany interfejs użytkownika, współpracuje z płytkami: Arduino Uno, Leonardo, Nucleo i XNucleo.<br><br>  <h4>Specyfikacja</h4> <ul> <li>Zasilnie: ze złącz Arduino</li> <li>Kompatybilny z modułami Arduino Uno, Leonardo, Nucleo i XNucleo</li> <li>Wspierane formaty audio: <ul> <li>MP3</li> <li>AAC</li> <li>WMA</li> <li>WAV</li> <li>MIDI, itp.</li><ul> </li> <li>Możliwość odtwarzania plików audio bezpośrednio z karty we wbudowanym slocie SD</li> <li>Wbudowany mikrofon</li> <li>Wbudowane złącze słuchawkowe jack</li> <li>Wbudowany konwerter poziomów logicznych 74VHC125</li> <li>Moduł kompatybilny z mikrokontrolerami 3,3 V i 5 V</li> <li>Wbudowany joystick ułatwiający nawigację (głośniej/ciszej/przewijanie przód/tył/odtwarzaj/pauza)</li> <li>Wymiary płytki: 53 x 55 x 20 mm</li></ul>', 7, 9, '2019-05-29 21:12:07', '2019-05-29 21:12:07', NULL),
(15, 7200015, 'Zasilacz microUSB 5,1V', 2, 37.99, 42.99, 'zasilacz-microusb-51v.jpg', 'Oryginalny zasilacz do minikomputera Raspberry Pi z końcówką microUSB. Współpracuje  modelami 3B+, 3B+ 2B, 1B+, 1B, 1A oraz Zero i Zero W. Maksymalna wydajność prądowa wynosi 2,5 A.', '<h4>Opis</h4> Oryginalny zasilacz z końcówką microUSB o maksymalnej wydajności prądowej 2,5 A dedykowany do minikomputera Raspberry Pi w wersji 3 model B i B+, współpracuje również z modelami 2B, B+ i A+ oraz Zero i Zero W. Urządzenie może zasilać również minikomputer LattePanda.<br><br>  <h4>Specyfikacja</h4> <ul> <li>Model T5989DV</li> <li>Napięcie wejściowe: AC 100 V - 240 V / 50-60 Hz</li> <li>Napięcie wyjściowe: DC 5,1 V</li> <li>Prąd wyjściowy: do 2,5 A</li> <li>Złącze: wtyk microUSB</li> <li>Kolor obudowy: czarny</li></ul>', 4, 20, '2019-05-29 21:21:24', '2019-05-29 21:21:24', NULL),
(16, 7200016, 'Zasilacz impulsowy 12V / 2,5A', 2, 24.99, 17.99, 'zasilacz-impulsowy-12v.jpg', 'Stabilizowany zasilacz sieciowy. Napięcie zasilania: od 100 V do 240 V. Napięcie wyjściowe: 12 V DC. Prąd wyjściowy: 2,5 A. Złącze: wtyk DC 5,5 / 2,5 m (kompatybilny z 5,5 / 2,1 mm).', '<h4>Specyfikacja</h4> <ul> <li>Napięcie zasilania: 100 do 240 V AC</li> <li>Napięcie wyjściowe: 12 V DC</li> <li>Prąd wyjściowy: 2,5 A</li> <li>Złącze: wtyk DC 5,5 / 2,5 mm (kompatybilny z 5,5 / 2,1 mm)</li> <li>Zasilacz stabilizowany, zasilacz sieciowy</li> <li>Długość przewodu: ok. 150 cm</li></ul>', 4, 20, '2019-05-29 21:21:24', '2019-05-29 21:21:24', NULL),
(17, 72000017, 'Przewody połączeniowe żeńsko-żeńskie 20cm', 2, 7.99, NULL, 'przewody-polaczeniowe-zenskiex2.jpg', 'Zestaw zawiera 40 szt. różnokolorowych przewodów połączeniowych o długości 20 cm zakończonych z obu stron złączem żeńskim na goldpin.', '<h4>Opis</h4> Zestaw zawiera 40 szt. wielokolorowych przewodów połączeniowych o długości 20cm. Zakończone są z obu stron złączem żeńskim. Przewody można rozdzielać na pojedyncze sztuki. Doskonale nadają się do łączenia pól na płytkach stykowych i zestawach uruchomieniowych (np. Raspberry Pi, STM32Discovery). Długość przewodu to 20 cm.<br><br>', 4, 30, '2019-05-29 21:21:24', '2019-05-29 21:21:24', NULL),
(18, 72000018, 'Przewody połączeniowe męsko-męskie 20cm', 2, 7.99, NULL, 'przewody-polaczeniowe-meskiex2.jpg', 'Zestaw zawiera 40 szt. wielokolorowych przewodów połączeniowych o długości 20 cm zakończonych z obu stron złączem męskim.', '<h4>Opis</h4> Zestaw zawiera 40 szt. różnokolorowych przewodów połączeniowych o długości 20 cm. Zakończone są z obu stron złączem męskim typu goldpin. Przewody można rozdzielać na pojedyncze sztuki. doskonale nadają się do łączenia pól na płytkach stykowych i zestawach uruchomieniowych (np. Arduino, STM32Discovery). Długość przewodu to 20 cm.<br><br>', 4, 30, '2019-05-29 21:21:24', '2019-05-29 21:21:24', NULL),
(19, 72000019, 'Przewody połączeniowe żeńsko-męskie 20cm', 2, 7.99, NULL, 'przewody-polaczeniowe-ultra.jpg', 'Zestaw zawiera 40 szt. różnokolorowych przewodów połączeniowych o długości 20 cm zakończonych z jednej strony złączem żeńskim, z drugiej końcówką męska.', '<h4>Opis</h4> Zestaw zawiera 40 szt różnokolorowych przewodów połączeniowych o długości 20 cm. Zakończone są z jednej strony złączem żeńskim, z drugiej końcówką męska. Przewody można rozdzielać na pojedyncze sztuki. Przewody doskonale nadają się do łączenia pól na płytkach stykowych i w zestawach (np.: Arduino lub STM32Discovery). Długość przewodu 20cm.<br><br>', 4, 30, '2019-05-29 21:21:24', '2019-05-29 21:21:24', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `users`
--

CREATE TABLE `users` (
  `user_id` bigint(20) NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_polish_ci NOT NULL,
  `surname` varchar(64) COLLATE utf8mb4_polish_ci NOT NULL,
  `city` varchar(32) COLLATE utf8mb4_polish_ci NOT NULL,
  `street` varchar(32) COLLATE utf8mb4_polish_ci DEFAULT NULL,
  `home_num` varchar(12) COLLATE utf8mb4_polish_ci NOT NULL,
  `email` varchar(64) COLLATE utf8mb4_polish_ci DEFAULT NULL,
  `passwd` varchar(256) COLLATE utf8mb4_polish_ci DEFAULT NULL,
  `phone` int(9) NOT NULL,
  `postcode` varchar(6) COLLATE utf8mb4_polish_ci NOT NULL,
  `discount` float DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `users`
--

INSERT INTO `users` (`user_id`, `name`, `surname`, `city`, `street`, `home_num`, `email`, `passwd`, `phone`, `postcode`, `discount`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Krystian', 'Pomorski', 'Zagórze', NULL, '132', 'kzamorski@poczta.pl', '$2y$10$YhHIiLso5s19TM.At86.IuVbHXLhVds3HAm3RNbovtiRz.JICOQHG', 987654321, '36-314', 0, '2019-05-16 21:52:46', '2019-05-28 20:37:09', NULL),
(2, 'Mariusz', 'Strzyga', 'Pierścienice', 'ul. Krucza', '13a', 'mar-strzyga@online.pl', '$2y$10$.BNvNFRNCh3winQ/4QUXxetf866z0.ZAhNZqcgSXNxVTe15t0q76y', 765394824, '36-432', 0, '2019-05-16 22:03:10', '2019-05-16 22:03:10', NULL),
(3, 'Szymon', 'Koterba', 'Niemcy', NULL, '32', 'koter32@czytaj.com.pl', '$2y$10$Opqz1t4Blr.yfmJpU0Nxc.EJ6Vatrp2OuZUHcumGPn4NyOBVE6jDe', 123235651, '21-324', 0, '2019-05-16 22:03:10', '2019-05-16 22:03:10', NULL),
(4, 'Konstancja', 'Tymoszewicz', 'Kartuzy', 'ul.Cyrkowa', '13/24', 'elektra-tymczasowa@omlet.pl', '$2y$10$WgUzw5yz1TgGn5XGc6CNLOe3wnSxa1Y1.XfPfkUyCZtzvYQQ.NYDS', 777667577, '10-124', 0, '2019-05-16 22:03:10', '2019-05-16 22:03:10', NULL),
(5, 'Test', 'Test', 'Rzeszów', 'ul. Zamkowa', '12', 'test@test.pl', '$2y$10$IE2Gp.fOShg6yAmSkik8Fu9SUnlMGGW/vbXrn3kfvCgXfZPtQJtXe', 0, '10-001', 0, '2019-05-20 18:50:16', '2019-05-20 18:50:16', NULL);

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`article_id`);

--
-- Indeksy dla tabeli `basket`
--
ALTER TABLE `basket`
  ADD KEY `product_id` (`product_id`);

--
-- Indeksy dla tabeli `couriers`
--
ALTER TABLE `couriers`
  ADD PRIMARY KEY (`kurier_id`);

--
-- Indeksy dla tabeli `gen_passwd_log`
--
ALTER TABLE `gen_passwd_log`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `manufacture`
--
ALTER TABLE `manufacture`
  ADD PRIMARY KEY (`manufacture_id`);

--
-- Indeksy dla tabeli `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `kurier_id` (`kurier_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `order_price_type` (`order_price_type`),
  ADD KEY `basket_id` (`basket_id`);

--
-- Indeksy dla tabeli `pay_type`
--
ALTER TABLE `pay_type`
  ADD PRIMARY KEY (`pay_type_id`);

--
-- Indeksy dla tabeli `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `manufacture_id` (`manufacture_id`);
ALTER TABLE `products` ADD FULLTEXT KEY `prod_name` (`prod_name`);

--
-- Indeksy dla tabeli `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT dla tabeli `articles`
--
ALTER TABLE `articles`
  MODIFY `article_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT dla tabeli `couriers`
--
ALTER TABLE `couriers`
  MODIFY `kurier_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT dla tabeli `gen_passwd_log`
--
ALTER TABLE `gen_passwd_log`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT dla tabeli `manufacture`
--
ALTER TABLE `manufacture`
  MODIFY `manufacture_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT dla tabeli `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT dla tabeli `pay_type`
--
ALTER TABLE `pay_type`
  MODIFY `pay_type_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT dla tabeli `products`
--
ALTER TABLE `products`
  MODIFY `product_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT dla tabeli `users`
--
ALTER TABLE `users`
  MODIFY `user_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `basket`
--
ALTER TABLE `basket`
  ADD CONSTRAINT `basket_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);

--
-- Ograniczenia dla tabeli `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`kurier_id`) REFERENCES `couriers` (`kurier_id`),
  ADD CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`order_price_type`) REFERENCES `pay_type` (`pay_type_id`);

--
-- Ograniczenia dla tabeli `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`manufacture_id`) REFERENCES `manufacture` (`manufacture_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
