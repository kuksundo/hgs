/* --------------------------------------------------------
Creates database TreeGridTest for all TreeGrid examples. 
Primarily used for MySQL.
!! MySQL must be in UTF8 encoding to store the characters correctly !!
This script can be run on database by:

mysql.exe -uroot -p < MySqlUTF8.sql

Update paths or copy MySqlUTF8.sql to the MySQL /bin directory a run it here

To use MySQL database in the PHP examples, for example add in Basic.php:

require_once("../Framework/IncDbMySQL.php");
$db = new Database("TreeGridTest","root","your root password");

-- --------------------------------------------------------*/

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: 'TreeGridTest'
--
DROP DATABASE IF EXISTS TreeGridTest;
CREATE DATABASE IF NOT EXISTS TreeGridTest DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE TreeGridTest;

-- --------------------------------------------------------

--
-- Table 'GanttBasic'
--

DROP TABLE IF EXISTS GanttBasic;
CREATE TABLE IF NOT EXISTS GanttBasic (
  T varchar(255) collate utf8_unicode_ci default NULL,
  S varchar(255) collate utf8_unicode_ci default NULL,
  E varchar(255) collate utf8_unicode_ci default NULL,
  C int(11) default NULL,
  D varchar(255) collate utf8_unicode_ci default NULL,
  id varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Data 'GanttBasic'
--

INSERT INTO GanttBasic (T, S, E, C, D, id) VALUES
('Task 1','5/18/2008','5/20/2008',100,'2','1'),
('Task 2','5/21/2008','5/30/2008',25,'8','2'),
('Task 3','5/14/2008','5/21/2008',100,'5','3'),
('Task 5','5/22/2008','5/24/2008',100,'6','5'),
('Task 6','5/25/2008','5/29/2008',50,'7','6'),
('Task 7','5/30/2008','5/31/2008',0,'8','7'),
('Task 8','6/1/2008','6/2/2008',0,'9','8'),
('Task 9','6/3/2008','6/3/2008',0,'10','9'),
('Task 10','6/4/2008','6/5/2008',0,'20','10'),
('Task 11','5/22/2008','5/26/2008',30,'12','11'),
('Task 12','5/27/2008','5/30/2008',0,'13','12'),
('Task 13','5/31/2008','',0,'10','13'),
('Task 14','5/14/2008','5/20/2008',100,'15;11','14'),
('Task 15','5/21/2008','5/22/2008',50,'16;18','15'),
('Task 16','5/23/2008','5/27/2008',0,'','16'),
('Task 17','5/14/2008','5/21/2008',90,'16','17'),
('Task 18','5/24/2008','6/2/2008',100,'19','18'),
('Task 19','6/3/2008','6/5/2008',20,'20','19'),
('Task 20','6/6/2008','',0,'','20');


-- --------------------------------------------------------

--
-- Table 'GanttTree'
--

DROP TABLE IF EXISTS GanttTree;
CREATE TABLE IF NOT EXISTS GanttTree (
  T varchar(255) collate utf8_unicode_ci default NULL,
  S varchar(255) collate utf8_unicode_ci default NULL,
  E varchar(255) collate utf8_unicode_ci default NULL,
  C int(11) default NULL,
  D varchar(255) collate utf8_unicode_ci default NULL,
  id varchar(255) collate utf8_unicode_ci default NULL,
  L varchar(255) collate utf8_unicode_ci default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Data 'GanttTree'
--

INSERT INTO GanttTree (T, S, E, C, D, id, L) VALUES
('Subtask 1','5/18/2008','5/20/2008',100,'2','1','Task 1'),
('Subtask 2','5/21/2008','5/30/2008',25,'8','2','Task 1'),
('Subtask 1','5/14/2008','5/21/2008',100,'5','3','Task 2'),
('Subtask 2-1','5/22/2008','5/24/2008',100,'6','5','Task 2/Subtask 2'),
('Subtask 2-2','5/25/2008','5/29/2008',50,'7','6','Task 2/Subtask 2'),
('Subtask 2-3','5/30/2008','5/31/2008',0,'8','7','Task 2/Subtask 2'),
('Subtask 3','6/1/2008','6/2/2008',0,'9','8','Task 2'),
('Subtask 4','6/3/2008','6/3/2008',0,'10','9','Task 2'),
('Subtask 5','6/4/2008','6/5/2008',0,'20','10','Task 2'),
('Subtask 6','5/22/2008','5/26/2008',30,'12','11','Task 2'),
('Subtask 7','5/27/2008','5/30/2008',0,'13','12','Task 2'),
('Subtask 8','5/31/2008','',0,'10','13','Task 2'),
('Subtask 1','5/14/2008','5/20/2008',100,'15;11','14','Task 3'),
('Subtask 2','5/21/2008','5/22/2008',50,'16;18','15','Task 3'),
('Subtask 3','5/23/2008','5/27/2008',0,'','16','Task 3'),
('Subtask 4','5/14/2008','5/21/2008',90,'16','17','Task 3'),
('Subtask 1','5/24/2008','6/2/2008',100,'19','18','Task 4'),
('Subtask 2','6/3/2008','6/5/2008',20,'20','19','Task 4'),
('Subtask 3','6/6/2008','',0,'','20','Task 4');


-- --------------------------------------------------------

--
-- Table 'Run'
--

DROP TABLE IF EXISTS Run;
CREATE TABLE IF NOT EXISTS Run (
  T varchar(255) collate utf8_unicode_ci default NULL,
  S varchar(255) collate utf8_unicode_ci default NULL,
  R varchar(2047) collate utf8_unicode_ci default NULL,
  id varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Data 'GanttBasic'
--

INSERT INTO Run (T, S, R, id) VALUES
('Task 1','5/16/2008','8,Box,One normal box with tooltip,,Tooltip for the box','1'),
('Task 2','5/14/2008','8,,Normal boxes with length: %n;;2,,%n;;4,,%n;;5,,%n days;;1,,%n;;2,,%n','2'),
('Task 3','5/12/2008','6,,Not adjacent boxes;2,empty;3;1,empty;4;1,empty;3;0,empty;2;2,empty;1;2,empty,Empty;4','3'),
('Task 4','5/15/2008','6,,Joined boxes;3;4;5;2;3;4','4'),
('Task 5','5/12/2008','7,,Joined boxes with spaces;2,nbsp;3;1,nbsp;4;1,nbsp;5;2;3,nbsp,Empty;3','5'),
('Task 6','5/16/2008','2,end,Start;;6,Box,Task with start;3;;2;;2,empty;2;7,empty;2','6'),
('Task 7','5/16/2008','6,Box,Task with end;3;;2;;4,empty;2;5,empty;2;;2,end,End','7'),
('Task 8','5/16/2008','2,end,Start;;6,Box,Task with both;3;;2;;6,empty;2;3,empty;2;;2,end,End','8'),
('Task 9','5/16/2008','2,bound,Start;;9,Box,Task with fixed start and end;;2;;8,empty;2;1,empty;2;;2,bound,End','9'),
('Task 10','5/12/2008','4,,Fixed boxes;1,empty;2,fixed,Fixed;1,empty;3;1,empty;2;1,empty;3,Left,Fixed left;1,empty;2;1,empty;4,Right,Fixed right;1,empty;2','10'),
('Task 11','5/12/2008','4,,Solid boxes;2,empty;3,solid,Solid;1,empty;4,solid,Solid;1,empty;3;0,empty;2,solid,Solid;2,empty;1;2,empty;4,solid,Solid','11'),
('Task 12','5/12/2008','7,,Errors - overlaying boxes;2,empty;3,,1.;-2;3,,2. Error;2,empty;5,,3.;-4;3,,4. Error;5,empty;5,,5.;-6;3,,6. Error;2,empty;3,,7. Error','12'),
('Task 13','5/12/2008','6,,Boxes with classes;;2,,Red,Red;;2,,Blue,Blue;;2,,Green,Green;1,empty;3,,Fuchsia,Fuchsia;;2,,Aqua,Aqua;;2,,Lime,Lime;1,empty;3,,Maroon,Maroon;;2,,Navy,Navy;;2,,Olive,Olive;1,empty;4,,Custom 1,Custom1','13'),
('Task 14','5/12/2008','6,,Boxes with classes;;3,,Orange,Orange;1,empty;2,,Purple,Purple;;2,,Silver,Silver;1,empty;2,,Teal,Teal;;3,,Yellow,Yellow;1,empty;2,,Black,Black;;2,,Gray,Gray;;2,,White,White;1,empty;4,,Custom 2,Custom2','14'),
('Task 15','5/12/2008','6,,Classes for spaces;2,empty,,Yellow;3;1,empty,,Yellow;4;1,empty,,Yellow;3;0,empty,,Yellow;2;2,nbsp,,Silver;1;2,empty,Empty,Lime;4','15'),
('Task 16','','','16');
