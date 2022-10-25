Create Database Banco
Go
Use Banco
Go
Create table TransaccionBanco 
(
TransactionID Int IDENTITY(1,1),
N_Cuenta Nvarchar(25) Not Null,
FechaTrans Datetime Not Null Default Getdate(), 
TipoTrans Nvarchar(25) Not Null,
MontoTrans Money Default '0',
Balance Money Default '0' ,
Primary Key(TransactionID) 
);
Go

Create Table Cliente
(
Id_Cliente Int Primary Key Not Null,
Nombre Nvarchar(15) Not Null,
Direccion Nvarchar(30) Not Null,
)
Go

Create Table Cuenta
(
Id_Cuenta Int primary key Not Null,
TipoMoneda Nvarchar(10) Not Null,
Monto Float Not Null,
Cliente Int Foreign Key References Cliente(Id_Cliente)
)
Go

-- Crear Deposito
Begin Transaction Deposito
Update Cuenta
Set Monto = Monto + 1000
Where Cuenta.Cliente = 1  
Save Transaction P1
Rollback Transaction P1
Commit Transaction Cuenta
Go

-- Crear Retiro
Begin transaction Retiro
Update Cuenta
Set Monto = Monto - 1000
Where Cuenta.Cliente = 1 and Monto >=0
Save Transaction P1
Rollback Transaction P1
Commit Transaction Retiro
Go

Insert Into Cliente Values (2,'Leandro-Kun','Managua')
Select * From Cliente
Go

Insert Into Cuenta Values (2,'Cordoba',35000,2)
Select * From Cuenta
Go

-- 1. Crear una Tabla Temporal: Movimientos
-- Que permita registrar, ya sea Depositos, Retiros, Pagos, Trasferencias y Actualizar el Saldo
-- 2. Manejando lo que es la transaccion explicita
-- Gestionar tanto la Transferencia de forma local (Del mismo Banco), como la transferencia CH (Otro banco)
-- Considere que la Tranferencia CH tiene un costo de aproximadamente $2

Use Banco
Go
-- 1
Create Table #Movimientos 
(
TransactionID Int IDENTITY(1,1),
N_Cuenta Nvarchar(25) Not Null,
FechaTrans Datetime Not Null Default Getdate(), 
TipoTrans Nvarchar(25) Not Null,
MontoTrans Money Default '0',
Balance Money Default '0' ,
Primary Key(TransactionID) 
);
Go

Insert Into #Movimientos Values(1,2,GetDate(),'Deposito',1000,1000)
Select * From #Movimientos

-- 2:
-- Tranferencia Local
Begin Transaction Transferencia
Update Cuenta
Set Monto = Monto - 1000
Where Cuenta.Cliente = 1 and Monto >=0
Save Transaction P1
Rollback Transaction P1
Update Cuenta
Set Monto = Monto + 1000
Where Cuenta.Cliente = 2
Save Transaction P2
Rollback Transaction P2
Commit Transaction Trans
Go

-- Tranferencia CH
Begin Transaction TransferenciaCH
Update Cuenta
Set Monto = Monto - 1000
Where Cuenta.Cliente = 1 and Monto >=0
Save Transaction P1
Rollback Transaction P1
Update Cuentas
Set Montos = Montos + 1000
Where Cuentas.Clientes = 2
Save Transaction P2
Rollback Transaction P2
Commit Transaction TransCH
Go