%%%%%%%%%%%%%%%%%%%%%%%%%%% Defining and testing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A robot can't execute 2 actions at same time
:- occurs(object(robot,RobotID),Action1,TimeStep), occurs(object(robot,RobotID),Action2,TimeStep), Action1!=Action2.

% No robot collision allowed
:- 2{robotLocation(RobotID,object(node,NodeID),TimeStep):robot(RobotID)}, node(NodeID), TimeStep=1..t.
:- robotLocation(R1,object(node,N1),T), robotLocation(R1,object(node,N2),T+1), robotLocation(R2,object(node,N2),T), robotLocation(R2,object(node,N1),T+1), R1!=R2.
:- not {robotLocation(RobotID,object(node,NodeID),TimeStep):node(NodeID)} = 1, robot(RobotID), TimeStep=1..t.
:- robotLocation(RobotID,object(node,NodeID),TimeStep), robotMove(RobotID,move(DeltaRow,DeltaCol),TimeStep), nodeAt(NodeID,pair(Row,Col)), Row+DeltaRow<1.
:- robotLocation(RobotID,object(node,NodeID),TimeStep), robotMove(RobotID,move(DeltaRow,DeltaCol),TimeStep), nodeAt(NodeID,pair(Row,Col)), Col+DeltaCol<1.
:- robotLocation(RobotID,object(node,NodeID),TimeStep), robotMove(RobotID,move(DeltaRow,DeltaCol),TimeStep), nodeAt(NodeID,pair(Row,Col)), Row+DeltaRow>RowCount, rowSize(RowCount).
:- robotLocation(RobotID,object(node,NodeID),TimeStep), robotMove(RobotID,move(DeltaRow,DeltaCol),TimeStep), nodeAt(NodeID,pair(Row,Col)), Col+DeltaCol>ColCount, colSize(ColCount).
robotLocation(RobotID,object(node,NewNodeID),TimeStep+1):- robotLocation(RobotID,object(node,NodeID),TimeStep), nodeAt(NodeID,pair(Row,Col)), nodeAt(NewNodeID,pair(Row+DeltaRow,Col+DeltaCol)), robotMove(RobotID,move(DeltaRow,DeltaCol),TimeStep).
robotLocation(RobotID,object(node,NodeID),TimeStep+1):- robotLocation(RobotID,object(node,NodeID),TimeStep), not robotMove(RobotID,move(_,_),TimeStep), TimeStep<t.

% Shelves
:- 2{shelfLocatedAt(ShelfID,object(node,NodeID),TimeStep): node(NodeID)}, shelf(ShelfID), TimeStep=1..t.
:- 2{shelfLocatedAt(ShelfID,object(node,NodeID),TimeStep): shelf(ShelfID)}, node(NodeID), TimeStep=1..t.
:- shelfLocatedAt(ShelfID,object(node,_),TimeStep), shelfLocatedAt(ShelfID,object(robot,_),TimeStep).
:- putShelfDown(RobotID,ShelfID,TimeStep), robotLocation(RobotID,object(node,NodeID),TimeStep), highway(NodeID).
:- shelfLocatedAt(ShelfID,object(node,NodeID),_), highway(NodeID).

:- 2{pickShelfUp(RobotID,ShelfID,TimeStep): robot(RobotID)} , shelf(ShelfID).
:- shelfLocatedAt(S1,object(node,NodeID),TimeStep), shelfLocatedAt(S2,object(robot,RobotID),TimeStep), robotLocation(RobotID,object(node,NodeID),TimeStep), S1!=S2.
:- pickShelfUp(RobotID,S1,TimeStep), shelfLocatedAt(S2,object(robot,RobotID),TimeStep).
:- pickShelfUp(R1,ShelfID,TimeStep), shelfLocatedAt(ShelfID,object(robot,R2),TimeStep).
:- pickShelfUp(RobotID,ShelfID,TimeStep), shelfLocatedAt(ShelfID,object(node,NodeID),TimeStep), not robotLocation(RobotID,object(node,NodeID),TimeStep).
:- 2 {putShelfDown(RobotID,ShelfID,TimeStep): robot(RobotID)}, shelf(ShelfID).
:- putShelfDown(RobotID,ShelfID,TimeStep), not shelfLocatedAt(ShelfID,object(robot,RobotID),TimeStep).
:- 2{shelfLocatedAt(ShelfID,object(robot,RobotID),TimeStep): robot(RobotID)}, shelf(ShelfID), TimeStep=1..t.
:- 2{shelfLocatedAt(ShelfID,object(robot,RobotID),TimeStep): shelf(ShelfID)}, robot(RobotID), TimeStep=1..t.
shelfLocatedAt(ShelfID,object(robot,RobotID),TimeStep+1):- pickShelfUp(RobotID,ShelfID,TimeStep), shelfLocatedAt(ShelfID,object(node,NodeID),TimeStep), robotLocation(RobotID,object(node,NodeID),TimeStep).
shelfLocatedAt(ShelfID,object(node,NodeID),TimeStep+1):-shelfLocatedAt(ShelfID,object(node,NodeID),TimeStep), not pickShelfUp(_,ShelfID,TimeStep), TimeStep<t.
shelfLocatedAt(ShelfID,object(node,NodeID),TimeStep+1):- putShelfDown(RobotID,ShelfID,TimeStep), shelfLocatedAt(ShelfID,object(robot,RobotID),TimeStep), robotLocation(RobotID,object(node,NodeID),TimeStep).
shelfLocatedAt(ShelfID,object(robot,RobotID),TimeStep+1):-shelfLocatedAt(ShelfID,object(robot,RobotID),TimeStep), not putShelfDown(RobotID,ShelfID,TimeStep), TimeStep<t.

%%%%%%%% Minimize time, show and constant %%%%%%%%
#minimize{TimeStep:occurs(Object,Action,TimeStep)}.
#show occurs/3.
#const t=20.
