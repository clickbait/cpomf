doctype html
html
  head
    title = @title ? "Pomf - #{@title}" : "Pomf"

    meta name="viewport" content="width=device-width, initial-scale=1"
  body
    - child.call
