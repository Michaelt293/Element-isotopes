{-|
Module      : Isotope
Description : Isotope is a chemistry library for calculating masses of elements
              and molecules.
Copyright   : Michael Thomas
License     : GPL-3
Maintainer  : Michael Thomas <Michaelt293@gmail.com>
Stability   : Experimental

-}
module Isotope
  ( IsotopicMass
  , IsotopicAbundance
  , ElementName
  , AtomicNumber
  , ProtonNumber
  , NeutronNumber
  , Nucleons
  , MassNumber
  , IntegerMass
  , MonoisotopicMass
  , NominalMass
  , AverageMass
  , Isotope(..)
  , Element(..)
  , ElementSymbol(..)
  , MolecularFormula
  , elementSymbolList
  , ElementSymbolMap(..)
  , mkElementSymbolMap
  , lookup
  , (!)
  , ChemicalMass(..)
  , elements
  , lookupElement
  , elementName
  , atomicNumber
  , isotopes
  , mostAbundantIsotope
  , selectIsotope
  , integerMasses
  , isotopicMasses
  , isotopicAbundances
  , emptyMolecularFormula
  , renderMolecularFormula
  , (|+|)
  ) where

import Isotope.Base
import Prelude hiding (lookup)
