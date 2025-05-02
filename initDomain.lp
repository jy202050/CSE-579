%%%%%%%%%%%%%%%%% Generating search space %%%%%%%%%%%%%%%%%%%%%%
% Row size
rowSize(RowCount):- RowCount=#count{Row:init(object(node,NodeID),value(at,pair(Row,Col)))}.
% Column size
colSize(ColCount):- ColCount=#count{Col:init(object(node,NodeID),value(at,pair(Row,Col)))}.
% Total robots
totalRobots(RobotCount):- RobotCount=#count{RobotID:init(object(robot,RobotID),value(at,pair(Row,Col)))}.
% Total nodes
totalNodes(NodeCount):- NodeCount=#count{NodeID:init(object(node,NodeID),value(at,pair(Row,Col)))}.
% Total shelves
totalShelves(ShelfCount):- ShelfCount=#count{ShelfID:init(object(shelf,ShelfID),value(at,pair(Row,Col)))}.
% Total products
totalProducts(ProductCount):- ProductCount=#count{ProductID:init(object(product,ProductID),value(on,pair(ShelfID,Quantity)))}.
% Total picking stations
totalPickingStations(PickingStationCount):- PickingStationCount=#count{PSID:init(object(pickingStation,PSID),value(at,pair(Row,Col)))}.
% Total orders
totalOrders(OrderCount):- OrderCount=#count{OrderID:init(object(order,OrderID),value(pickingStation,PS))}.


% Nodes and pairs
node(NodeID):- init(object(node,NodeID),value(at,pair(Row,Col))).
nodeAt(NodeID,pair(Row,Col)):- init(object(node,NodeID),value(at,pair(Row,Col))).
pair(Row,Col):- init(object(node,NodeID),value(at,pair(Row,Col))).


% Highways
highway(NodeID):- init(object(highway,NodeID),value(at,pair(Row,Col))).

% Picking stations
pickingStationAt(PSID,NodeID):- init(object(pickingStation,PSID),value(at,pair(Row,Col))), init(object(node,NodeID),value(at,pair(Row,Col))).
pickingStation(PSID):- init(object(pickingStation,PSID),value(at,pair(Row,Col))), init(object(node,NodeID),value(at,pair(Row,Col))).

% Robots
robotLocation(RobotID,object(node,NodeID),0):- init(object(robot,RobotID),value(at,pair(Row,Col))), nodeAt(NodeID,pair(Row,Col)).
robot(RobotID):- init(object(robot,RobotID),value(at,pair(Row,Col))).

% Shelves
shelfLocatedAt(ShelfID,object(node,NodeID),0):- init(object(shelf,ShelfID),value(at,pair(Row,Col))), nodeAt(NodeID,pair(Row,Col)).
shelf(ShelfID):- init(object(shelf,ShelfID),value(at,pair(Row,Col))).

% Products
productLocatedAt(ProductID,object(shelf,ShelfID),with(quantity,Quantity),0):- init(object(product,ProductID),value(on,pair(ShelfID,Quantity))).
product(ProductID):- init(object(product,ProductID),value(on,pair(ShelfID,Quantity))).

% Orders
orderLocation(OrderID,object(node,NodeID),contains(ProductID,Quantity),0):- init(object(order,OrderID),value(pickingStation,PSID)), pickingStationAt(PSID,NodeID), init(object(order,OrderID),value(line,pair(ProductID,Quantity))).
order(OrderID):- init(object(order,OrderID),value(pickingStation,PSID)).
