module Constants exposing
    ( bluish
    , catDelayMillis
    , grayish
    , greenish
    , maxCol
    , maxRow
    , numCols
    , numInitBlocks
    , numRows
    , orangish
    , spotHeight
    , spotRadius
    )


numInitBlocks =
    7


catDelayMillis : Float
catDelayMillis =
    300


-- BOARD DIMENSIONS

numCols =
    11


maxCol =
    numCols - 1


numRows =
    11


maxRow =
    numRows - 1


-- SPOT SIZE

spotRadius =
    5


-- | Depends on shape!
spotHeight =
    spotRadius * 1.85


-- COLORS

orangish =
    "#F0AD00"


greenish =
    "#7FD13B"


bluish =
    "#60B5CC"


grayish =
    "#5A6378"
