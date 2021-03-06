{-# Language OverloadedStrings #-}
module Database.SQL.SQLSolvent.IOFunctions (

    getSchemeGraph
    ,tnames
    ,redirectScheme
    ,getFile
    ,    csvFile

    
) where

import Database.SQL.SQLSolvent.Functions
import Database.SQL.SQLSolvent.Types
import Control.Exception


import Data.Graph.Inductive.Graph 
import Data.Graph.Inductive
import qualified System.IO.Strict as Strict

import Data.Attoparsec.Text
import qualified Data.Set as S
import qualified Data.Text as T 



--для консольный отладочный стафф 
csvpath = "example.csv"
   
getSchemeGraph :: IO (Gr Table RelWIthId)
getSchemeGraph = do
    scheme <- redirectScheme csvpath
    return $ buildTableGraph scheme
  
tnames :: Gr Table RelationInGraph -> [Node] -> [TableName]
tnames graph nodes  = fmap (\node -> case (lab graph node) of
                                            Just a -> tName a 
                                            Nothing -> T.pack "") nodes
                                            

    
--IO

getFile :: FilePath -> IO T.Text
getFile fp = do
    file <- Strict.readFile fp
    return $ T.pack file 


redirectScheme :: String -> IO Scheme
redirectScheme path = do
    file <- getFile path
    let raw = case (parseOnly csvFile file) of
                Right a -> a
                Left _ -> [[]]
      
    return $ getScheme raw


