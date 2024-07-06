--==============================================================
--******                G O V E R N O R S                 ******
--==============================================================

--=============================================================================================
--=                                        MOKSHA                                             =
--=============================================================================================

-- 06/07/24 Governor rework
-- Moksha 4 turns
UPDATE Governors SET TransitionStrength=125 WHERE GovernorType='GOVERNOR_THE_CARDINAL';

-- Delete moksha's scrapped abilities
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
DELETE FROM GovernorPromotionPrereqs WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR PrereqGovernorPromotion='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_GRAND_INQUISITOR' OR GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_LAYING_ON_OF_HANDS';

-- Base Bishop : +15% culture in city. Religious pressure to adjacent cities in 100% stronger from this city. +2 Faith per specialty district in this city.             
UPDATE GovernorPromotionModifiers SET GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_BISHOP' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_LIBRARIAN' AND ModifierId='LIBRARIAN_CULTURE_YIELD_BONUS';

-- LI Conoisseur : +1 culture per population. Ignores pressure and combat effects from Religions not founded by the Governor's player.    
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR';
UPDATE GovernorPromotionSets SET GovernorType='GOVERNOR_THE_CARDINAL' WHERE GovernorPromotion='GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR';
UPDATE GovernorPromotions SET Column=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR';
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR', 'GOVERNOR_PROMOTION_CARDINAL_BISHOP');
UPDATE GovernorPromotionModifiers SET GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR' WHERE ModifierId IN ('CARDINAL_CITADEL_OF_GOD_PRESSURE', 'CARDINAL_CITADEL_OF_GOD_COMBAT');

-- RI Citadel of gods :  Your trade route ending here provide +2 culture to their starting city. Gain Faith equal to 25% of the construction cost when finishing buildings.  
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD';  
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD', 'GOVERNOR_PROMOTION_CARDINAL_BISHOP'); 
UPDATE GovernorPromotions SET Level=1, Column=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD';

INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_MOKSHA_DOMESTIC_TRADE_ROUTE_2_CULTURE', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_MOKSHA_DOMESTIC_TRADE_ROUTE_2_CULTURE', 'Amount', '2'),
    ('BBG_MOKSHA_DOMESTIC_TRADE_ROUTE_2_CULTURE', 'Domestic', '1'),
    ('BBG_MOKSHA_DOMESTIC_TRADE_ROUTE_2_CULTURE', 'YieldType', 'YIELD_CULTURE');
INSERT INTO GovernorPromotionModifiers(GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD', 'BBG_MOKSHA_DOMESTIC_TRADE_ROUTE_2_CULTURE');

-- LII Divine Architect : Ability to faith buy district. Apostles/Warrior monks trained in the city receive one extra Promotion. 
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT';
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT', 'GOVERNOR_PROMOTION_EDUCATOR_CONNOISSEUR');
UPDATE GovernorPromotions SET Level=2, Column=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT';     
        
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_UNIT_TYPE_IS_MONK', 'REQUIREMENT_UNIT_TYPE_MATCHES');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_UNIT_TYPE_IS_MONK', 'UnitType', 'UNIT_WARRIOR_MONK');
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('BBG_UNIT_TYPE_IS_MONK_REQSET', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('BBG_UNIT_TYPE_IS_MONK_REQSET', 'BBG_REQUIRES_UNIT_TYPE_IS_MONK');
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('BBG_MOKSHA_MONK_FREE_PROMO', 'MODIFIER_CITY_TRAINED_UNITS_ADJUST_GRANT_EXPERIENCE', 'BBG_UNIT_TYPE_IS_MONK_REQSET');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_MOKSHA_MONK_FREE_PROMO', 'Amount', '-1');
INSERT INTO GovernorPromotionModifiers(GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT', 'BBG_MOKSHA_MONK_FREE_PROMO');
UPDATE GovernorPromotionModifiers SET GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT' WHERE ModifierId='CARDINAL_PATRON_SAINT_PROMOTION';

-- RII Patron Saint : Your trade route ending here provide +1 culture to their starting city. Grant the ability to faith buy support unit in the city.  
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT';      
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT', 'GOVERNOR_PROMOTION_CARDINAL_CITADEL_OF_GOD');
UPDATE GovernorPromotions SET Level=2, Column=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT';

INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_MOKSHA_DOMESTIC_TRADE_ROUTE_1_CULTURE', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_MOKSHA_DOMESTIC_TRADE_ROUTE_1_CULTURE', 'Amount', '1'),
    ('BBG_MOKSHA_DOMESTIC_TRADE_ROUTE_1_CULTURE', 'Domestic', '1'),
    ('BBG_MOKSHA_DOMESTIC_TRADE_ROUTE_1_CULTURE', 'YieldType', 'YIELD_CULTURE');
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_MOKSHA_FAITH_BUY_SUPPORT_UNIT', 'MODIFIER_CITY_ENABLE_UNIT_FAITH_PURCHASE');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MOKSHA_FAITH_BUY_SUPPORT_UNIT', 'Tag', 'CLASS_SUPPORT');
INSERT INTO GovernorPromotionModifiers(GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT', 'BBG_MOKSHA_DOMESTIC_TRADE_ROUTE_1_CULTURE'),
    ('GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT', 'BBG_MOKSHA_FAITH_BUY_SUPPORT_UNIT'); 

-- M3 Curator : Double Tourism from Great Works of Art, Music and Writing in the city.   
UPDATE GovernorPromotionSets SET GovernorType='GOVERNOR_THE_CARDINAL' WHERE GovernorPromotion='GOVERNOR_PROMOTION_MERCHANT_CURATOR';
UPDATE GovernorPromotions SET Column=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_CURATOR';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_CURATOR';
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_MERCHANT_CURATOR', 'GOVERNOR_PROMOTION_CARDINAL_DIVINE_ARCHITECT'),
    ('GOVERNOR_PROMOTION_MERCHANT_CURATOR', 'GOVERNOR_PROMOTION_CARDINAL_PATRON_SAINT');   



--=============================================================================================
--=                                       PINGALA                                             =
--=============================================================================================

-- 4 turns
UPDATE Governors SET TransitionStrength=125 WHERE GovernorType='GOVERNOR_THE_EDUCATOR';

-- Default Librarian : +15% Science generated by the city.

-- LI Grants :  +100% GPP generation
UPDATE GovernorPromotions SET Level=1, Column=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_GRANTS';
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_EDUCATOR_GRANTS', 'GOVERNOR_PROMOTION_EDUCATOR_LIBRARIAN');

-- RI Researcher : +1 science per population        
        
-- LII Eureka : +3 science for Library / +5 science for University / +7 science for Research Lab        
INSERT INTO Types (Type, Kind) VALUES
    ('BBG_GOVERNOR_PROMOTION_EDUCATOR_CAMPUS_BUILDING_YIELDS', 'KIND_GOVERNOR_PROMOTION');
INSERT INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES
    ('GOVERNOR_THE_EDUCATOR', 'BBG_GOVERNOR_PROMOTION_EDUCATOR_CAMPUS_BUILDING_YIELDS');
INSERT INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, Column, BaseAbility) VALUES
    ('BBG_GOVERNOR_PROMOTION_EDUCATOR_CAMPUS_BUILDING_YIELDS', 'LOC_GOVERNOR_PROMOTION_EDUCATOR_EUREKA_NAME', 'LOC_GOVERNOR_PROMOTION_EDUCATOR_EUREKA_DESCRIPTION', 2, 0, 0);

INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_EDUCATOR_BOOST_LIBRARY', 'MODIFIER_BUILDING_YIELD_CHANGE'),
    ('BBG_EDUCATOR_BOOST_UNIVERSITY', 'MODIFIER_BUILDING_YIELD_CHANGE'),
    ('BBG_EDUCATOR_BOOST_LAB', 'MODIFIER_BUILDING_YIELD_CHANGE');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_EDUCATOR_BOOST_LIBRARY', 'BuildingType', 'BUILDING_LIBRARY'),
    ('BBG_EDUCATOR_BOOST_UNIVERSITY', 'BuildingType', 'BUILDING_UNIVERSITY'),
    ('BBG_EDUCATOR_BOOST_LAB', 'BuildingType', 'BUILDING_RESEARCH_LAB'),
    ('BBG_EDUCATOR_BOOST_LIBRARY', 'YieldType', 'YIELD_SCIENCE'),
    ('BBG_EDUCATOR_BOOST_UNIVERSITY', 'YieldType', 'YIELD_SCIENCE'),
    ('BBG_EDUCATOR_BOOST_LAB', 'YieldType', 'YIELD_SCIENCE'),
    ('BBG_EDUCATOR_BOOST_LIBRARY', 'Amount', '3'),
    ('BBG_EDUCATOR_BOOST_UNIVERSITY', 'Amount', '5'),
    ('BBG_EDUCATOR_BOOST_LAB', 'Amount', '7');
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('BBG_GOVERNOR_PROMOTION_EDUCATOR_CAMPUS_BUILDING_YIELDS', 'BBG_EDUCATOR_BOOST_LIBRARY'),
    ('BBG_GOVERNOR_PROMOTION_EDUCATOR_CAMPUS_BUILDING_YIELDS', 'BBG_EDUCATOR_BOOST_UNIVERSITY'),
    ('BBG_GOVERNOR_PROMOTION_EDUCATOR_CAMPUS_BUILDING_YIELDS', 'BBG_EDUCATOR_BOOST_LAB');
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('BBG_GOVERNOR_PROMOTION_EDUCATOR_CAMPUS_BUILDING_YIELDS', 'GOVERNOR_PROMOTION_EDUCATOR_GRANTS'),
    ('GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE', 'BBG_GOVERNOR_PROMOTION_EDUCATOR_CAMPUS_BUILDING_YIELDS');

-- RII Spread Knowledge : +1 food +3 science per internal traders to this city
INSERT INTO Types (Type, Kind) VALUES 
    ('BBG_GOVERNOR_PROMOTION_EDUCATOR_TRADE', 'KIND_GOVERNOR_PROMOTION');
INSERT INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES
    ('GOVERNOR_THE_EDUCATOR', 'BBG_GOVERNOR_PROMOTION_EDUCATOR_TRADE');
INSERT INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, Column, BaseAbility) VALUES
    ('BBG_GOVERNOR_PROMOTION_EDUCATOR_TRADE', 'LOC_GOVERNOR_PROMOTION_EDUCATOR_KNOWLEDGE_NAME', 'LOC_GOVERNOR_PROMOTION_EDUCATOR_KNOWLEDGE_DESCRIPTION', 2, 2, 0);

INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_PINGALA_SCIENCE_FROM_DOMESTIC_TRADE', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS'),
    ('BBG_PINGALA_FOOD_FROM_DOMESTIC_TRADE', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_PINGALA_SCIENCE_FROM_DOMESTIC_TRADE', 'Domestic', '1'),
    ('BBG_PINGALA_SCIENCE_FROM_DOMESTIC_TRADE', 'Amount', '3'),
    ('BBG_PINGALA_SCIENCE_FROM_DOMESTIC_TRADE', 'YieldType', 'YIELD_SCIENCE'),
    ('BBG_PINGALA_FOOD_FROM_DOMESTIC_TRADE', 'Domestic', '1'),
    ('BBG_PINGALA_FOOD_FROM_DOMESTIC_TRADE', 'Amount', '1'),
    ('BBG_PINGALA_FOOD_FROM_DOMESTIC_TRADE', 'YieldType', 'YIELD_FOOD');
 
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('BBG_GOVERNOR_PROMOTION_EDUCATOR_TRADE', 'BBG_PINGALA_SCIENCE_FROM_DOMESTIC_TRADE'),
    ('BBG_GOVERNOR_PROMOTION_EDUCATOR_TRADE', 'BBG_PINGALA_FOOD_FROM_DOMESTIC_TRADE');   
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('BBG_GOVERNOR_PROMOTION_EDUCATOR_TRADE', 'GOVERNOR_PROMOTION_EDUCATOR_RESEARCHER');    

-- MIII Space Initiative : +30% production toward space projects
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE';
UPDATE GovernorPromotions SET Column=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE';
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_EDUCATOR_SPACE_INITIATIVE', 'BBG_GOVERNOR_PROMOTION_EDUCATOR_TRADE');

--=============================================================================================
--=                                        MAGNUS                                             =
--=============================================================================================
-- MAGNUS: 4 turns moving (from 5) 
UPDATE Governors SET TransitionStrength=125 WHERE GovernorType='GOVERNOR_THE_RESOURCE_MANAGER';
-- Default Groundbreaker: +40% yields from 50% 
UPDATE ModifierArguments SET Value=40 WHERE ModifierId='GROUNDBREAKER_BONUS_HARVEST_YIELDS' AND Name='Amount';

-- 24/04/23 Magnus surplus logistics give 1 PM to Settler.
-- 06/07/23 REMOVED, now give +2 food and 20% growth
-- L1 Expedition : +20% Growth in the city. Internal traderoute +2 food 
UPDATE GovernorPromotionModifiers SET GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_EXPEDITION' WHERE ModifierId='SURPLUS_LOGISTICS_TRADE_ROUTE_FOOD';
UPDATE GovernorPromotionModifiers SET GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_EXPEDITION' WHERE ModifierId='SURPLUS_LOGISTICS_EXTRA_GROWTH';
UPDATE GovernorPromotions SET Level=1, Column=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_EXPEDITION';


-- 06/07/23 RI Industrialist: +25% Production toward Industrial Zone buildings in the city. Settlers trained in the city do not consume a Citizen Population. 
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST';
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_GOVERNOR_MAGNUS_PROD_IZ', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_PRODUCTION');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_GOVERNOR_MAGNUS_PROD_IZ', 'DistrictType', 'DISTRICT_INDUSTRIAL_ZONE'),
    ('BBG_GOVERNOR_MAGNUS_PROD_IZ', 'Amount', 20);
INSERT INTO GovernorPromotionModifiers(GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST', 'BBG_GOVERNOR_MAGNUS_PROD_IZ');
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_RESOURCE_MANAGER_GROUNDBREAKER' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST';
UPDATE GovernorPromotions SET Level=1, Column=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST';
UPDATE GovernorPromotionModifiers SET GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST' WHERE ModifierId='EXPEDITION_ADJUST_SETTLERS_CONSUME_POPULATION';

-- 24/04/23 Magnus' expedition gives +2 production to domestic trade routes
-- 10/03/24 Swapped with +2 food promotion
-- 06/07/24 LII Surplus Logistic : +1 production to internal traders 
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_RESOURCE_MANAGER_EXPEDITION' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_SURPLUS_LOGISTICS';
UPDATE GovernorPromotions SET Level=2, Column=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_SURPLUS_LOGISTICS';
INSERT INTO Modifiers(ModifierId, ModifierType) VALUES
    ('BBG_MAGNUS_DOMESTIC_TRADE_ROUTE_PROD', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('BBG_MAGNUS_DOMESTIC_TRADE_ROUTE_PROD', 'Amount', '1'),
    ('BBG_MAGNUS_DOMESTIC_TRADE_ROUTE_PROD', 'Domestic', '1'),
    ('BBG_MAGNUS_DOMESTIC_TRADE_ROUTE_PROD', 'YieldType', 'YIELD_PRODUCTION');
INSERT INTO GovernorPromotionModifiers(GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_RESOURCE_MANAGER_SURPLUS_LOGISTICS', 'BBG_MAGNUS_DOMESTIC_TRADE_ROUTE_PROD');

-- RII Arms Race:  Workshop +2/factory +4/ powerplant +7 production in the city where established + 4 electricity (from +4prod/+4 electricity in power plant)
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_RESOURCE_MANAGER_INDUSTRIALIST' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
UPDATE GovernorPromotions SET Level=2, Column=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER';
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_MAGNUS_PRODUCTION_WORKSHOP', 'MODIFIER_BUILDING_YIELD_CHANGE'),
    ('BBG_MAGNUS_PRODUCTION_FACTORY', 'MODIFIER_BUILDING_YIELD_CHANGE');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_MAGNUS_PRODUCTION_WORKSHOP', 'BuildingType', 'BUILDING_WORKSHOP'),
    ('BBG_MAGNUS_PRODUCTION_WORKSHOP', 'YieldType', 'YIELD_PRODUCTION'),
    ('BBG_MAGNUS_PRODUCTION_WORKSHOP', 'Amount', 2),
    ('BBG_MAGNUS_PRODUCTION_FACTORY', 'BuildingType', 'BUILDING_FACTORY'),
    ('BBG_MAGNUS_PRODUCTION_FACTORY', 'YieldType', 'YIELD_PRODUCTION'),
    ('BBG_MAGNUS_PRODUCTION_FACTORY', 'Amount', 4);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER', 'BBG_MAGNUS_PRODUCTION_WORKSHOP'),
    ('GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER', 'BBG_MAGNUS_PRODUCTION_FACTORY'),
    ('GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER', 'INDUSTRIALIST_COAL_POWER_PLANT_PRODUCTION'),
    ('GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER', 'INDUSTRIALIST_OIL_POWER_PLANT_PRODUCTION'),
    ('GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER', 'INDUSTRIALIST_NUCLEAR_POWER_PLANT_PRODUCTION'),
    ('GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER', 'INDUSTRIALIST_RESOURCE_POWER_PROVIDED');
UPDATE ModifierArguments SET Value=7 WHERE ModifierId LIKE 'INDUSTRIALIST%PRODUCTION' AND Name='Amount';
UPDATE ModifierArguments SET Value=4 WHERE ModifierId='INDUSTRIALIST_RESOURCE_POWER_PROVIDED' AND Name='Amount';

-- MIII Vertical Integration
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION';
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION', 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_BLACK_MARKETEER'),
    ('GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION', 'GOVERNOR_PROMOTION_RESOURCE_MANAGER_SURPLUS_LOGISTICS');
UPDATE GovernorPromotions SET Level=3, Column=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_RESOURCE_MANAGER_VERTICAL_INTEGRATION';



--=============================================================================================
--=                                       VIKTOR                                              =
--=============================================================================================

-- 3 turns

-- Base Redoubt : Increase city garrison CS by 5.               

-- LI Garrison Commander : Units defending within the city's territory get +3 CS. Your other cities within 9 tiles gain +4 Loyalty per turn towards your civilization.
UPDATE ModifierArguments SET Value=3 WHERE ModifierId='GARRISON_COMMANDER_ADJUST_CITY_COMBAT_BONUS' AND Name='Amount';

-- RI Defense Logistics : +25% production towards military units in this city       
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_DEFENSE_LOGISTICS';

INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_VIKTOR_PRODUCTION_UNITS', 'MODIFIER_SINGLE_CITY_ADJUST_UNIT_PRODUCTION_MODIFIER');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_VIKTOR_PRODUCTION_UNITS', 'Amount', 25);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_DEFENSE_LOGISTICS', 'BBG_VIKTOR_PRODUCTION_UNITS');

-- LII Embrasure : City cannot be sieged. +1 attack for city.
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EMBRASURE'; 
UPDATE GovernorPromotions SET Column=0 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EMBRASURE';
DELETE FROM GovernorPromotionModifiers WHERE ModifierId='CITY_DEFENDER_FREE_PROMOTIONS';
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_EMBRASURE', 'DEFENSE_LOGISTICS_SIEGE_PROTECTION');
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('GOVERNOR_PROMOTION_EMBRASURE', 'GOVERNOR_PROMOTION_GARRISON_COMMANDER');

-- RII Arms Race : Units produced in this city start with one promotion. Units does not cost strategics in this city. +50% towards nuclear weapon projects      
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_DEFENSE_LOGISTICS' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_ARMS_RACE_PROPONENT'; 
UPDATE GovernorPromotions SET Level=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_EDUCATOR_ARMS_RACE_PROPONENT';
UPDATE ModifierArguments SET Value='100' WHERE ModifierId='BLACK_MARKETEER_STRATEGIC_RESOURCE_COST_DISCOUNT' AND Name='Amount';
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_EDUCATOR_ARMS_RACE_PROPONENT', 'CITY_DEFENDER_FREE_PROMOTIONS'),
    ('GOVERNOR_PROMOTION_EDUCATOR_ARMS_RACE_PROPONENT', 'BLACK_MARKETEER_STRATEGIC_RESOURCE_COST_DISCOUNT');

-- MII Air Defense Initiative : +25 CS to anti air support unit within the city's territory when defending against aircraft and ICMBs.
UPDATE GovernorPromotions SET Column=1 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AIR_DEFENSE_INITIATIVE';


--=============================================================================================
--=                                       AMANI                                               =
--=============================================================================================
-- Amani Abuse Fix... can immediately re-declare war when an enemy suzerian removes Amani
UPDATE GlobalParameters SET Value='1' WHERE Name='DIPLOMACY_PEACE_MIN_TURNS';
-- new 1st on left promo for Amani
INSERT OR IGNORE INTO Types (Type, Kind) VALUES ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'KIND_GOVERNOR_PROMOTION');
INSERT OR IGNORE INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES ('GOVERNOR_THE_AMBASSADOR', 'GOVERNOR_PROMOTION_NEGOTIATOR_BBG');
INSERT OR IGNORE INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, 'Column')
    VALUES
        ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'LOC_GOVERNOR_PROMOTION_AMBASSADOR_NEGOTIATOR_NAME', 'LOC_GOVERNOR_PROMOTION_AMBASSADOR_NEGOTIATOR_DESCRIPTION', 1, 0);
INSERT OR IGNORE INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
    VALUES
        ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'DEFENDER_ADJUST_CITY_DEFENSE_STRENGTH'),
        ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'DEFENSE_LOGISTICS_SIEGE_PROTECTION');
INSERT OR IGNORE INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion)
    VALUES
        ('GOVERNOR_PROMOTION_NEGOTIATOR_BBG', 'GOVERNOR_PROMOTION_AMBASSADOR_MESSENGER');
-- move Amani's Emissary to 2nd on left
UPDATE GovernorPromotions SET Level=2 WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY';
UPDATE GovernorPromotionPrereqs SET GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_PUPPETEER' WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY';
UPDATE GovernorPromotionPrereqs SET PrereqGovernorPromotion='GOVERNOR_PROMOTION_NEGOTIATOR_BBG' WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY';
INSERT OR IGNORE INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
        ('GOVERNOR_PROMOTION_AMBASSADOR_EMISSARY', 'PRESTIGE_IDENTITY_PRESSURE_TO_DOMESTIC_CITIES');
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='EMISSARY_IDENTITY_PRESSURE_TO_FOREIGN_CITIES' AND Name='Amount';
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='PRESTIGE_IDENTITY_PRESSURE_TO_DOMESTIC_CITIES' AND Name='Amount';
-- Delete Amani's Foreign Investor
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
DELETE FROM GovernorPromotionPrereqs WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_AMBASSADOR_FOREIGN_INVESTOR';

--Amani Traders
INSERT INTO Requirements(RequirementId, RequirementType) VALUES
    ('PLAYER_HAS_CS_AMANI_CITY_FLAG_REQ', 'REQUIREMENT_PLOT_PROPERTY_MATCHES'),
    ('CITY_HAS_OWN_AMANI_TRADEROUT_REQ', 'REQUIREMENT_PLOT_PROPERTY_MATCHES');
INSERT INTO RequirementArguments(RequirementId, Name, Value) VALUES
    ('PLAYER_HAS_CS_AMANI_CITY_FLAG_REQ', 'PropertyName', 'AMANI_ESTABLISHED_CS'),
    ('PLAYER_HAS_CS_AMANI_CITY_FLAG_REQ', 'PropertyMinimum', '1'),
    ('CITY_HAS_OWN_AMANI_TRADEROUT_REQ', 'PropertyName', 'TRADER_TO_AMANI_CS'),
    ('CITY_HAS_OWN_AMANI_TRADEROUT_REQ', 'PropertyMinimum', '1');
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
    ('CITY_HAS_OWN_AMANI_TRADEROUT_REQSET_BBG', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
    ('CITY_HAS_OWN_AMANI_TRADEROUT_REQSET_BBG', 'PLAYER_HAS_CS_AMANI_CITY_FLAG_REQ'),
    ('CITY_HAS_OWN_AMANI_TRADEROUT_REQSET_BBG', 'CITY_HAS_OWN_AMANI_TRADEROUT_REQ');
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('CS_AMANI_GIVES_2_FOOD_MODIFIER_BBG', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE', 'CITY_HAS_OWN_AMANI_TRADEROUT_REQSET_BBG'),
    ('CS_AMANI_GIVES_2_PROD_MODIFIER_BBG', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE', 'CITY_HAS_OWN_AMANI_TRADEROUT_REQSET_BBG');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
    ('CS_AMANI_GIVES_2_FOOD_MODIFIER_BBG', 'YieldType', 'YIELD_FOOD'),
    ('CS_AMANI_GIVES_2_FOOD_MODIFIER_BBG', 'Amount', 2),
    ('CS_AMANI_GIVES_2_PROD_MODIFIER_BBG', 'YieldType', 'YIELD_PRODUCTION'),
    ('CS_AMANI_GIVES_2_PROD_MODIFIER_BBG', 'Amount', 2);    
INSERT INTO TraitModifiers(TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_MAJOR_CIV', 'CS_AMANI_GIVES_2_FOOD_MODIFIER_BBG'),
    ('TRAIT_LEADER_MAJOR_CIV', 'CS_AMANI_GIVES_2_PROD_MODIFIER_BBG');


--=============================================================================================
--=                                        LIANG                                              =
--=============================================================================================

-- Liang changes are in xp2/Governors.sql


--=============================================================================================
--=                                        LIANG                                              =
--=============================================================================================

-- Delete Reyna's old one
DELETE FROM GovernorPromotionModifiers WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
DELETE FROM GovernorPromotionPrereqs WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
DELETE FROM GovernorPromotionPrereqs WHERE PrereqGovernorPromotion='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
DELETE FROM GovernorPromotionSets WHERE GovernorPromotion='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';
DELETE FROM GovernorPromotions WHERE GovernorPromotionType='GOVERNOR_PROMOTION_MERCHANT_RENEWABLE_ENERGY';

-- 4 turns
UPDATE Governors SET TransitionStrength=125 WHERE GovernorType='GOVERNOR_THE_MERCHANT';

-- Default Land Acquisition : Acquire new tiles in the city faster. +4 golds for foreign traders going through this city.
UPDATE ModifierArguments SET Value='4' WHERE ModifierId='FOREIGN_EXCHANGE_GOLD_FROM_FOREIGN_TRADE_PASSING_THROUGH' AND Name='Amount';

-- LI Harbormaster : Double adjacency bonuses from Commercial Hubs and Harbor in the city.      

-- RI Forestry Management : This city receives +2 gold for each uninproved feature which also grant +1 appeal. +4 gold per internal traders. +1 traderoute capacity.        
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('BBG_REQUIRES_PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS', 'REQUIREMENT_REQUIREMENTSET_IS_MET');
INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('BBG_REQUIRES_PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS', 'RequirementSetId', 'PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS');
INSERT INTO RequirementSets VALUES
    ('BBG_PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_OR_BREATHTAKING_REQSET', 'REQUIREMENTSET_TEST_ANY');
INSERT INTO RequirementSetRequirements VALUES
    ('BBG_PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_OR_BREATHTAKING_REQSET', 'BBG_REQUIRES_PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS'),
    ('BBG_PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_OR_BREATHTAKING_REQSET', 'REQUIRES_PLOT_BREATHTAKING_APPEAL');
UPDATE Modifiers SET SubjectRequirementSetId='BBG_PLOT_HAS_ANY_FEATURE_NO_IMPROVEMENTS_OR_BREATHTAKING_REQSET' WHERE ModifierId='FORESTRY_MANAGEMENT_FEATURE_NO_IMPROVEMENT_GOLD';
        
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_REYNA_TRADEROUTE', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_REYNA_TRADEROUTE', 'Amount', '1');
INSERT INTO GovernorPromotionModifiers VALUES
    ('GOVERNOR_PROMOTION_MERCHANT_FORESTRY_MANAGEMENT', 'BBG_REYNA_TRADEROUTE');

INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_REYNA_GOLD_FROM_DOMESTIC_TRADE', 'MODIFIER_SINGLE_CITY_ADJUST_TRADE_ROUTE_YIELD_TO_OTHERS');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_REYNA_GOLD_FROM_DOMESTIC_TRADE', 'Domestic', '1'),
    ('BBG_REYNA_GOLD_FROM_DOMESTIC_TRADE', 'Amount', '4'),
    ('BBG_REYNA_GOLD_FROM_DOMESTIC_TRADE', 'YieldType', 'YIELD_GOLD');

INSERT INTO GovernorPromotionModifiers VALUES
    ('GOVERNOR_PROMOTION_MERCHANT_FORESTRY_MANAGEMENT', 'BBG_REYNA_GOLD_FROM_DOMESTIC_TRADE');

-- MII Tax Collector : +2 gold per turn for each citizen in the city. +1 traderoute capacity. 
-- +1 trade route
INSERT INTO GovernorPromotionModifiers VALUES
    ('GOVERNOR_PROMOTION_MERCHANT_TAX_COLLECTOR', 'BBG_REYNA_TRADEROUTE');

-- LIII Contractor : Allow city to purchase districts with gold. Building cost reduced by 50%. Support unit buy reduced by 50%      
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_REYNA_BUILDING_GOLD_DISCOUNT', 'MODIFIER_SINGLE_CITY_ADJUST_ALL_BUILDINGS_PURCHASE_COST');
INSERT INTO Modifiers (ModifierId, ModifierType)
    SELECT 'BBG_REYNA_' || UnitType || '_GOLD_DISCOUNT', 'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_PURCHASE_COST' FROM Units WHERE FormationClass='FORMATION_CLASS_SUPPORT';
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_REYNA_BUILDING_GOLD_DISCOUNT', 'Amount', 50);
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    SELECT 'BBG_REYNA_' || UnitType || '_GOLD_DISCOUNT', 'UnitType', UnitType FROM Units WHERE FormationClass='FORMATION_CLASS_SUPPORT';
INSERT INTO ModifierArguments (ModifierId, Name, Value)
    SELECT 'BBG_REYNA_' || UnitType || '_GOLD_DISCOUNT', 'Amount', 50 FROM Units WHERE FormationClass='FORMATION_CLASS_SUPPORT';

INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('GOVERNOR_PROMOTION_MERCHANT_CONTRACTOR', 'BBG_REYNA_BUILDING_GOLD_DISCOUNT');

INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId)
    SELECT 'GOVERNOR_PROMOTION_MERCHANT_CONTRACTOR', 'BBG_REYNA_' || UnitType || '_GOLD_DISCOUNT' FROM Units WHERE FormationClass='FORMATION_CLASS_SUPPORT';

-- RIII Foreign Exchange : +2 science/culture for foreign traders going through this city.      
INSERT INTO Types (Type, Kind) VALUES
    ('BBG_GOVERNOR_PROMOTION_MANAGER', 'KIND_GOVERNOR_PROMOTION');
INSERT INTO GovernorPromotionSets (GovernorType, GovernorPromotion) VALUES
    ('GOVERNOR_THE_MERCHANT', 'BBG_GOVERNOR_PROMOTION_MANAGER');
INSERT INTO GovernorPromotions (GovernorPromotionType, Name, Description, Level, Column) VALUES
    ('BBG_GOVERNOR_PROMOTION_MANAGER', 'LOC_GOVERNOR_PROMOTION_MERCHANT_INVESTOR_NAME', 'LOC_GOVERNOR_PROMOTION_MERCHANT_INVESTOR_DESCRIPTION', 3, 2);
INSERT INTO GovernorPromotionPrereqs (GovernorPromotionType, PrereqGovernorPromotion) VALUES
    ('BBG_GOVERNOR_PROMOTION_MANAGER', 'GOVERNOR_PROMOTION_MERCHANT_TAX_COLLECTOR');

INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('BBG_REYNA_SCIENCE_FROM_FOREIGN_TRADER', 'MODIFIER_CITY_ADJUST_YIELD_FROM_FOREIGN_TRADE_ROUTES_PASSING_THROUGH'),
    ('BBG_REYNA_CULTURE_FROM_FOREIGN_TRADER', 'MODIFIER_CITY_ADJUST_YIELD_FROM_FOREIGN_TRADE_ROUTES_PASSING_THROUGH');
INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('BBG_REYNA_SCIENCE_FROM_FOREIGN_TRADER', 'YieldType', 'YIELD_SCIENCE'),
    ('BBG_REYNA_SCIENCE_FROM_FOREIGN_TRADER', 'Amount', 2),
    ('BBG_REYNA_CULTURE_FROM_FOREIGN_TRADER', 'YieldType', 'YIELD_CULTURE'),
    ('BBG_REYNA_CULTURE_FROM_FOREIGN_TRADER', 'Amount', 2);
INSERT INTO GovernorPromotionModifiers (GovernorPromotionType, ModifierId) VALUES
    ('BBG_GOVERNOR_PROMOTION_MANAGER', 'BBG_REYNA_SCIENCE_FROM_FOREIGN_TRADER'),
    ('BBG_GOVERNOR_PROMOTION_MANAGER', 'BBG_REYNA_CULTURE_FROM_FOREIGN_TRADER');