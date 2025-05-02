%Robot movement
move(0,1;0,-1;-1,0;1,0).
{robotMove(RobotID,move(DeltaRow,DeltaCol),TimeStep):move(DeltaRow,DeltaCol)}1 :- RobotID=1..RobotCount, totalRobots(RobotCount), TimeStep=1..t-1.
occurs(object(robot,RobotID),move(DeltaRow,DeltaCol),TimeStep):-robotMove(RobotID,move(DeltaRow,DeltaCol),TimeStep).

% Robot pick up shelves
{pickShelfUp(RobotID,ShelfID,TimeStep):shelf(ShelfID)}1:- RobotID=1..RobotCount, totalRobots(RobotCount), TimeStep=1..t-1.
occurs(object(robot,RobotID),pickup,TimeStep):-pickShelfUp(RobotID,_,TimeStep).

% Robot put down shelves
{putShelfDown(RobotID,ShelfID,TimeStep):shelf(ShelfID)}1:- RobotID=1..RobotCount, totalRobots(RobotCount), TimeStep=1..t-1.
occurs(object(robot,RobotID),putdown,TimeStep):-putShelfDown(RobotID,_,TimeStep).

% Robot delivers items
{deliver(RobotID,OrderID,with(ShelfID,ProductID,Quantity),TimeStep):orderLocation(OrderID,object(node,NodeID),contains(ProductID,RequiredQty),TimeStep), productLocatedAt(ProductID,object(shelf,ShelfID),with(quantity,AvailableQty),TimeStep), Quantity=1..AvailableQty}1 :- RobotID=1..RobotCount, totalRobots(RobotCount), TimeStep=1..t-1.
occurs(object(robot,RobotID),deliver(OrderID,ProductID,Quantity),TimeStep):- deliver(RobotID,OrderID,with(ShelfID,ProductID,Quantity),TimeStep).
