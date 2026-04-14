# Avoid same planning sorting
Whenever a new planning unit is created (for sheet 0), this codeunit ensures its Sorting Order doesn't collide with an existing planning unit that shares the same Unit and Capacity Unit, bumping the order up by 1 if a conflict is found.


# What this extension includes:

- An event subscriber (codeunit 80421) that check a potential sorting conflict after a new Planning Unit Record has been inserted.

