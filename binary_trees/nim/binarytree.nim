import os, strutils

type
  BinaryTree = ref object
    left, right: BinaryTree

proc newBinaryTree(left, right: BinaryTree): BinaryTree =
  BinaryTree(left: left, right: right)

proc countNodes(bt: BinaryTree): uint =
  if bt.left.isNil:
    return 1
  else:
    return 1 + bt.left.countNodes() + bt.right.countNodes()

proc createBottomUp(depth: uint): BinaryTree =
  if depth > 0'u:
    return newBinaryTree(createBottomUp(depth - 1), createBottomUp(depth - 1))
  else:
    return newBinaryTree(nil, nil)

when isMainModule:
  if paramCount() != 1:
    stderr.writeLine("Usage: binarytree <depth>")
    quit(1)

  let N =
    try:
      parseUInt(paramStr(1))
    except ValueError:
      stderr.writeLine("Invalid depth argument")
      quit(1)

  var minDepth: uint = 4
  var maxDepth: uint = N
  if (minDepth + 2) > maxDepth:
    maxDepth = minDepth + 2

  block:
    let stretchDepth = maxDepth + 1
    let stretchTree = createBottomUp(stretchDepth)
    echo "stretch tree of depth ", stretchDepth, "\t check: ", stretchTree.countNodes()

  let longLivedTree = createBottomUp(maxDepth)

  var check: uint
  for depth in countup(minDepth, maxDepth, 2):
    let iterations = 1 shl int(maxDepth - depth + minDepth)
    check = 0
    for i in 1 .. iterations:
      let tempTree = createBottomUp(depth)
      check += tempTree.countNodes()
    echo iterations, "\t trees of depth ", depth, "\t check: ", check

  echo "long lived tree of depth ", maxDepth, "\t check: ", longLivedTree.countNodes()

