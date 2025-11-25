CREATE TABLE parents AS
  SELECT "ace" AS parent, "bella" AS child UNION
  SELECT "ace"          , "charlie"        UNION
  SELECT "daisy"        , "hank"           UNION
  SELECT "finn"         , "ace"            UNION
  SELECT "finn"         , "daisy"          UNION
  SELECT "finn"         , "ginger"         UNION
  SELECT "ellie"        , "finn";

CREATE TABLE dogs AS
  SELECT "ace" AS name, "long" AS fur, 26 AS height UNION
  SELECT "bella"      , "short"      , 52           UNION
  SELECT "charlie"    , "long"       , 47           UNION
  SELECT "daisy"      , "long"       , 46           UNION
  SELECT "ellie"      , "short"      , 35           UNION
  SELECT "finn"       , "curly"      , 32           UNION
  SELECT "ginger"     , "short"      , 28           UNION
  SELECT "hank"       , "curly"      , 31;

CREATE TABLE sizes AS
  SELECT "toy" AS size, 24 AS min, 28 AS max UNION
  SELECT "mini"       , 28       , 35        UNION
  SELECT "medium"     , 35       , 45        UNION
  SELECT "standard"   , 45       , 60;


-- All dogs with parents ordered by decreasing height of their parent
CREATE TABLE by_parent_height AS
  SELECT p.child as child
  FROM parents p
  JOIN dogs d ON p.parent = d.name
  ORDER BY d.height DESC;


-- The size of each dog
CREATE TABLE size_of_dogs AS
  SELECT d.name, s.size
  FROM dogs d
  JOIN sizes s ON d.height > s.min AND d.height <= s.max;


-- [Optional] Filling out this helper table is recommended
CREATE TABLE siblings AS
  SELECT DISTINCT
            MIN(p1.child, p2.child) AS name1,
            MAX(p1.child, p2.child) AS name2,
            so1.size AS size
  FROM parents p1
  JOIN parents p2 ON p1.parent = p2.parent  -- 共享父母 = 真正的兄弟姐妹
  JOIN size_of_dogs so1 ON p1.child = so1.name 
  JOIN size_of_dogs so2 ON p2.child = so2.name 
  WHERE p1.child != p2.child 
    AND so1.size = so2.size;


-- Sentences about siblings that are the same size
CREATE TABLE sentences AS
  SELECT 'The two siblings, ' || name1 || ' and ' || name2 || ', have the same size: ' || size
    FROM siblings;


-- Height range for each fur type where all of the heights differ by no more than 30% from the average height
CREATE TABLE low_variance AS
  SELECT fur,(MAX(height)-MIN(height)) AS height_range
  FROM dogs
  GROUP BY fur
  HAVING MIN(height) >= 0.7 * AVG(height) 
    AND MAX(height) <= 1.3 * AVG(height);


