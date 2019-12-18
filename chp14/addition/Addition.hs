-- Addition.hs
module Addition where

-- Compiler parser doesn't have a means of recognizing import statements after
-- method declarations.
import Test.Hspec

main :: IO ()
main = hspec $ do
    describe "Addition" $ do
        it "1 + 1 is greater than 1" $ do
            (1 + 1) > 1 `shouldBe` True