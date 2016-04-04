{-|
Module      : Isotopic.Parsers
Description : Parsers for chemical and condensed formulae.
Copyright   : Michael Thomas
License     : GPL-3
Maintainer  : Michael Thomas <Michaelt293@gmail.com>
Stability   : Experimental

This module provides parsers for element symbols as well chemical and molecular
formulae. In addition, instances of `IsString` are provided.
-}
{-# LANGUAGE FlexibleInstances #-}
module Isotope.Parsers (
    -- * Parsers
      elementSymbol
    , subFormula
    , chemicalFormula
    , condensedFormula
    ) where

import Isotope.Base
import Text.Megaparsec
import Text.Megaparsec.String
import qualified Text.Megaparsec.Lexer as L
import Data.String
import Data.List hiding (filter)

-- | Parses an element symbol string.
elementSymbol :: Parser ElementSymbol
elementSymbol = read <$> choice (try . string <$> elementSymbolStrList)
    where elementList = show <$> elementSymbolList
          reverseLengthSort x y = length y `compare` length x
          elementSymbolStrList = sortBy reverseLengthSort elementList

-- | Parses an sub-formula (i.e., \"C2\").
subFormula :: Parser MolecularFormula
subFormula = do
    sym <- elementSymbol
    num <- optional L.integer
    return $ case num of
                  Nothing -> mkElementSymbolMap [(sym, 1)]
                  Just num' -> mkElementSymbolMap [(sym, fromIntegral num')]

-- | Parses a molecular formula (i.e. \"C6H6O\").
chemicalFormula :: Parser MolecularFormula
chemicalFormula = do
    formulas <- many subFormula
    return $ mconcat formulas

instance IsString MolecularFormula where
    fromString s =
      case parse (chemicalFormula <* eof) "" s of
           Left err -> error $ "Could not parse molecular formula: " ++ show err
           Right v  -> v

-- Helper function. Parses parenthesed sections in condensed formulae, i.e.,
-- the \"(CH3)3\" section of \"N(CH3)3\".
parenFormula :: Parser (Either MolecularFormula ([MolecularFormula], Int))
parenFormula = do
   _ <- char '('
   formula <- some subFormula
   _ <- char ')'
   num <- optional L.integer
   return $ Right $ case num of
                         Nothing -> (formula, 1)
                         Just num' -> (formula, fromIntegral num')

-- Helper function. Parses non-parenthesed sections in condensed formulae, i.e.,
-- the \"N\" section of \"N(CH3)3\".
leftMolecularFormula :: Parser (Either MolecularFormula ([MolecularFormula], Int))
leftMolecularFormula = do
   formula <- subFormula
   return $ Left formula

-- | Parsers a condensed formula, i.e., \"N(CH3)3\".
condensedFormula :: Parser CondensedFormula
condensedFormula = many (leftMolecularFormula <|> parenFormula)

instance IsString CondensedFormula where
   fromString s =
     case parse (condensedFormula <* eof) "" s of
          Left err -> error $ "Could not parse condensed formula: " ++ show err
          Right v  -> v
