/* simple makevalid */
update <TABLE> set <FIELD> = <FIELD>.MakeValid() where <FIELD>.STIsValid() = 0

/* fix bad rings */
UPDATE <TABLE> SET <COL>=<COL>.MakeValid().ReorientObject() WHERE <COL>.MakeValid().EnvelopeAngle() > 90;