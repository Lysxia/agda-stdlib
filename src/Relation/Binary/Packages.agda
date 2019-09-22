------------------------------------------------------------------------
-- The Agda standard library
--
-- Packages for homogeneous binary relations
------------------------------------------------------------------------

-- Note that the definitions in this file are all re-exported by
-- `Relation.Binary`.

{-# OPTIONS --without-K --safe #-}

module Relation.Binary.Packages where

open import Level
open import Relation.Nullary using (¬_)
open import Relation.Binary.Core
open import Relation.Binary.Definitions
open import Relation.Binary.Structures

------------------------------------------------------------------------
-- Setoids
------------------------------------------------------------------------

record PartialSetoid a ℓ : Set (suc (a ⊔ ℓ)) where
  field
    Carrier              : Set a
    _≈_                  : Rel Carrier ℓ
    isPartialEquivalence : IsPartialEquivalence _≈_

  open IsPartialEquivalence isPartialEquivalence public

  _≉_ : Rel Carrier _
  x ≉ y = ¬ (x ≈ y)


record Setoid c ℓ : Set (suc (c ⊔ ℓ)) where
  infix 4 _≈_
  field
    Carrier       : Set c
    _≈_           : Rel Carrier ℓ
    isEquivalence : IsEquivalence _≈_

  open IsEquivalence isEquivalence public

  _≉_ : Rel Carrier _
  x ≉ y = ¬ (x ≈ y)

  partialSetoid : PartialSetoid c ℓ
  partialSetoid = record
    { isPartialEquivalence = isPartialEquivalence
    }


record DecSetoid c ℓ : Set (suc (c ⊔ ℓ)) where
  infix 4 _≈_
  field
    Carrier          : Set c
    _≈_              : Rel Carrier ℓ
    isDecEquivalence : IsDecEquivalence _≈_

  open IsDecEquivalence isDecEquivalence public

  setoid : Setoid c ℓ
  setoid = record
    { isEquivalence = isEquivalence
    }


------------------------------------------------------------------------
-- Preorders
------------------------------------------------------------------------

record Preorder c ℓ₁ ℓ₂ : Set (suc (c ⊔ ℓ₁ ⊔ ℓ₂)) where
  infix 4 _≈_ _∼_
  field
    Carrier    : Set c
    _≈_        : Rel Carrier ℓ₁  -- The underlying equality.
    _∼_        : Rel Carrier ℓ₂  -- The relation.
    isPreorder : IsPreorder _≈_ _∼_

  open IsPreorder isPreorder public


------------------------------------------------------------------------
-- Partial orders
------------------------------------------------------------------------

record Poset c ℓ₁ ℓ₂ : Set (suc (c ⊔ ℓ₁ ⊔ ℓ₂)) where
  infix 4 _≈_ _≤_
  field
    Carrier        : Set c
    _≈_            : Rel Carrier ℓ₁
    _≤_            : Rel Carrier ℓ₂
    isPartialOrder : IsPartialOrder _≈_ _≤_

  open IsPartialOrder isPartialOrder public

  preorder : Preorder c ℓ₁ ℓ₂
  preorder = record
    { isPreorder = isPreorder
    }


record DecPoset c ℓ₁ ℓ₂ : Set (suc (c ⊔ ℓ₁ ⊔ ℓ₂)) where
  infix 4 _≈_ _≤_
  field
    Carrier           : Set c
    _≈_               : Rel Carrier ℓ₁
    _≤_               : Rel Carrier ℓ₂
    isDecPartialOrder : IsDecPartialOrder _≈_ _≤_

  private
    module DPO = IsDecPartialOrder isDecPartialOrder
  open DPO public hiding (module Eq)

  poset : Poset c ℓ₁ ℓ₂
  poset = record
    { isPartialOrder = isPartialOrder
    }

  open Poset poset public using (preorder)

  module Eq where

    decSetoid : DecSetoid c ℓ₁
    decSetoid = record
      { isDecEquivalence = DPO.Eq.isDecEquivalence
      }

    open DecSetoid decSetoid public


record StrictPartialOrder c ℓ₁ ℓ₂ : Set (suc (c ⊔ ℓ₁ ⊔ ℓ₂)) where
  infix 4 _≈_ _<_
  field
    Carrier              : Set c
    _≈_                  : Rel Carrier ℓ₁
    _<_                  : Rel Carrier ℓ₂
    isStrictPartialOrder : IsStrictPartialOrder _≈_ _<_

  open IsStrictPartialOrder isStrictPartialOrder public


record DecStrictPartialOrder c ℓ₁ ℓ₂ : Set (suc (c ⊔ ℓ₁ ⊔ ℓ₂)) where
  infix 4 _≈_ _<_
  field
    Carrier                 : Set c
    _≈_                     : Rel Carrier ℓ₁
    _<_                     : Rel Carrier ℓ₂
    isDecStrictPartialOrder : IsDecStrictPartialOrder _≈_ _<_

  private
    module DSPO = IsDecStrictPartialOrder isDecStrictPartialOrder
    open DSPO hiding (module Eq)

  strictPartialOrder : StrictPartialOrder c ℓ₁ ℓ₂
  strictPartialOrder = record
    { isStrictPartialOrder = isStrictPartialOrder
    }

  module Eq where

    decSetoid : DecSetoid c ℓ₁
    decSetoid = record
      { isDecEquivalence = DSPO.Eq.isDecEquivalence
      }

    open DecSetoid decSetoid public


------------------------------------------------------------------------
-- Total orders
------------------------------------------------------------------------

record TotalOrder c ℓ₁ ℓ₂ : Set (suc (c ⊔ ℓ₁ ⊔ ℓ₂)) where
  infix 4 _≈_ _≤_
  field
    Carrier      : Set c
    _≈_          : Rel Carrier ℓ₁
    _≤_          : Rel Carrier ℓ₂
    isTotalOrder : IsTotalOrder _≈_ _≤_

  open IsTotalOrder isTotalOrder public

  poset : Poset c ℓ₁ ℓ₂
  poset = record
    { isPartialOrder = isPartialOrder
    }

  open Poset poset public using (preorder)


record DecTotalOrder c ℓ₁ ℓ₂ : Set (suc (c ⊔ ℓ₁ ⊔ ℓ₂)) where
  infix 4 _≈_ _≤_
  field
    Carrier         : Set c
    _≈_             : Rel Carrier ℓ₁
    _≤_             : Rel Carrier ℓ₂
    isDecTotalOrder : IsDecTotalOrder _≈_ _≤_

  private
    module DTO = IsDecTotalOrder isDecTotalOrder
  open DTO public hiding (module Eq)

  totalOrder : TotalOrder c ℓ₁ ℓ₂
  totalOrder = record
    { isTotalOrder = isTotalOrder
    }

  open TotalOrder totalOrder public using (poset; preorder)

  module Eq where

    decSetoid : DecSetoid c ℓ₁
    decSetoid = record
      { isDecEquivalence = DTO.Eq.isDecEquivalence
      }

    open DecSetoid decSetoid public


-- Note that these orders are decidable. The current implementation
-- of `Trichotomous` subsumes irreflexivity and asymmetry. Any reasonable
-- definition capturing these three properties implies decidability
-- as `Trichotomous` necessarily separates out the equality case.

record StrictTotalOrder c ℓ₁ ℓ₂ : Set (suc (c ⊔ ℓ₁ ⊔ ℓ₂)) where
  infix 4 _≈_ _<_
  field
    Carrier            : Set c
    _≈_                : Rel Carrier ℓ₁
    _<_                : Rel Carrier ℓ₂
    isStrictTotalOrder : IsStrictTotalOrder _≈_ _<_

  open IsStrictTotalOrder isStrictTotalOrder public
    hiding (module Eq)

  strictPartialOrder : StrictPartialOrder c ℓ₁ ℓ₂
  strictPartialOrder =
    record { isStrictPartialOrder = isStrictPartialOrder }

  decSetoid : DecSetoid c ℓ₁
  decSetoid = record { isDecEquivalence = isDecEquivalence }

  module Eq = DecSetoid decSetoid
