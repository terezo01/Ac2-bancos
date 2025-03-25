create database ac1

use ac1


create table carros(
	placa char(7) primary key,
	modelo varchar(100),
	ano date
)

create table motoristas(
	motoristaId int primary key identity(1,1),
	nome varchar(100),
	cnh int,
	pontosCnh int
)

create table multas(
	multasId int primary key identity(1,1),
	placaCarro char(7),
	multaData date,
	pontos int
	constraint fk_carros_multas foreign key (placaCarro) references carros(placa)
)


create table prontuarios(
	prontuarioId int primary key identity(1,1),
	motoristaId int,
	multasId int,
	dataAssociacão date
	constraint fk_motoristas_prontuarios foreign key (motoristaId) references motoristas(motoristaId),
	constraint fk_multas_prontuarios foreign key (multasId) references multas(multasId)

)

create procedure inserirCarro
@placa char(7),
@modelo varchar(100),
@ano date
as
insert into carros(placa, modelo)
values(@placa, @modelo, @ano)
select * from carros

create procedure inserirMotorista
@nome varchar(100),
@cnh int,
@pontosCnh int
as
insert into motoristas(nome, cnh, pontosCnh)
values(@nome, @cnh, @pontosCnh)
select * from motoristas

create procedure inserirMulta
@placaCarro char(7),
@multaData date,
@pontos int
as
insert into multas(placaCarro, multaData, pontos)
values(@placaCarro, @multaData, @pontos)
select * from multas

create procedure inserirProntuario
@motoristaId int,
@multasId int,
@dataAssociacão date
as
insert into prontuarios(motoristaId, multasId, dataAssociacão)
values(@motoristaId, @multasId, @dataAssociacão)
select* from prontuarios



create trigger tgr_novaMulta
on multas for insert
as
begin
declare
	@multasId int,
	@placaCarro char(7),
	@multaData date,
	@pontos int
	select @multasId = multasId, @placaCarro = placaCarro, @multaData = multaData, @pontos = pontos from inserted
	update prontuarios set multasId = @multasId, dataAssociacão = @multaData
	where 
	
