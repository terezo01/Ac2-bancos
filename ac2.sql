create database ac1Bancos

use ac1Bancos


create table motoristas(
	motoristaId int primary key identity(1,1),
	nome varchar(100),
	cnh int,
	pontosCnh int
)

create table carros(
	placa char(7) primary key,
	motoristaId int,
	modelo varchar(100)
	constraint fk_motoristas_carros foreign key (motoristaId) references motoristas(motoristaId)
)


create table multas(
	multasId int primary key identity(1,1),
	motoristaId int,
	multaData date,
	pontos int
	constraint fk_motorista_multas foreign key (motoristaId) references motoristas(motoristaId),
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
@motoristaId int,
@modelo varchar(100)
as
insert into carros(placa, motoristaId, modelo)
values(@placa, @motoristaId, @modelo)
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
@motoristaId int,
@multaData date,
@pontos int
as
insert into multas(motoristaId, multaData, pontos)
values(@motoristaId, @multaData, @pontos)
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
	@motoristaId int,
	@multaData date,
	@pontos int
	select @multasId = multasId ,@motoristaId = motoristaId, @multaData = multaData, @pontos = pontos from inserted
	exec inserirProntuario @motoristaId, @multasId, @multaData
	update motoristas set pontosCnh = pontosCnh + @pontos
	where motoristaId = @motoristaId
end

create procedure todosMotoristas
as
select motoristas.nome, multas.multasId, motoristas.pontosCnh from motoristas
inner join multas on motoristas.motoristaId = multas.motoristaId

create procedure umMotorista
@motoristaId int
as
select motoristas.nome, multas.multasId, motoristas.pontosCnh from motoristas
inner join multas on motoristas.motoristaId = multas.motoristaId
where motoristas.motoristaId = @motoristaId

create procedure PontosMotorista
@motoristaId int
as
select motoristas.nome, motoristas.pontosCnh from motoristas
where motoristas.motoristaId = @motoristaId

exec inserirCarro 'abc9876', 2, 'argo'

exec inserirMotorista 'sergio', 12456658, 0

exec inserirMulta 1, '2020-01-30', 10

exec todosMotoristas 
