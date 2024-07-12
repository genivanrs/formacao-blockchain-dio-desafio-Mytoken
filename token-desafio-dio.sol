// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

// Interface padrão do token ERC20
interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

// Contrato do token DIOToken
contract DIOToken is ERC20Interface {
    string public symbol = "DIO";  // Símbolo do token
    string public name = "DIO Coin";  // Nome do token
    uint8 public decimals = 2;  // Casas decimais do token
    uint256 public _totalSupply;  // Suprimento total de tokens

    mapping(address => uint) balances;  // Saldo dos endereços
    mapping(address => mapping(address => uint)) allowed;  // Permissões de gasto

    // Construtor que define o suprimento inicial de tokens e atribui todos ao criador do contrato
    constructor() {
        _totalSupply = 1000000;
        balances[msg.sender] = _totalSupply;
    }

    // Função que retorna o suprimento total de tokens
    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    // Função que retorna o saldo de um endereço específico
    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    // Função de transferência de tokens
    function transfer(address to, uint tokens) public override returns (bool success) {
        require(tokens <= balances[msg.sender], "Saldo insuficiente");

        balances[msg.sender] -= tokens;
        balances[to] += tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    // Função para aprovar um endereço a gastar uma quantidade específica de tokens
    function approve(address spender, uint256 tokens) public override returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    // Função que retorna a quantidade de tokens que um endereço pode gastar de outro
    function allowance(address tokenOwner, address spender) public override view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    // Função para transferir tokens de um endereço para outro
    function transferFrom(address from, address to, uint256 tokens) public override returns (bool success) {
        require(tokens <= balances[from], "Saldo insuficiente");
        require(tokens <= allowed[from][msg.sender], "Limite de transferência excedido");

        balances[from] -= tokens;
        allowed[from][msg.sender] -= tokens;
        balances[to] += tokens;
        emit Transfer(from, to, tokens);
        return true;
    }
}
