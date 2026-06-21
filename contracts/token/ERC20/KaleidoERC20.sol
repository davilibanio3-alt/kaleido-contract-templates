pragma solidity ^0.6.2;
4b7c81a766a08916005d9dbd87314a3285fb1bba
[10/4 13:41] Davi Calixto: Site:<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>CalixtoSuper Network</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body { font-family: Arial; background:#0a0a0a; color:white; margin:0; }
    header { padding:40px; text-align:center; }
    h1 { font-size:40px; }
    section { padding:40px; max-width:900px; margin:auto; }
    .btn {
      display:inline-block; padding:12px 20px; margin:10px;
      background:#00ffcc; color:black; text-decoration:none; border-radius:8px;
    }
    ul { line-height: 1.8; }
  </style>
</head>
<body>

<header>
  <h1>CalixtoSuper Network</h1>
  <p>Ecossistema Web3 com utilidade real</p>
  <a class="btn" href="#">Comprar CALXT</a>
  <a class="btn" href="#">Ver Contrato</a>
</header>

<section>
  <h2>Sobre</h2>
  <p>CalixtoSuper é um ecossistema descentralizado focado em pagamentos, staking e infraestrutura Web3.</p>
</section>

<section>
  <h2>Tokenomics</h2>
  <p>Supply: 1.000.000.000 CALXT</p>
  <ul>
    <li>Liquidez: 60%</li>
    <li>Ecossistema: 15%</li>
    <li>Desenvolvimento: 10%</li>
    <li>Marketing: 10%</li>
    <li>Reserva: 5%</li>
  </ul>
</section>

<section>
  <h2>Utilidade</h2>
  <ul>
    <li>Pagamentos</li>
    <li>Staking</li>
    <li>Acesso a serviços</li>
  </ul>
</section>

<section>
  <h2>Roadmap</h2>
  <ul>
    <li>Deploy e PancakeSwap ✔</li>
    <li>Site ✔</li>
    <li>Staking 🔜</li>
    <li>CoinGecko 🔜</li>
  </ul>
</section>

</body>
</html>
[10/4 13:42] Davi Calixto: Stake
import express from "express";

const app = express();
app.use(express.json());

let stakes = [];

app.post("/stake", (req, res) => {
  const { wallet, amount } = req.body;

  stakes.push({
    wallet,
    amount,
    start: Date.now()
  });

  res.json({ success: true });
});

app.get("/reward/:wallet", (req, res) => {
  const user = stakes.find(s => s.wallet === req.params.wallet);

  if (!user) return res.json({ reward: 0 });

  const days = (Date.now() - user.start) / (1000 * 60 * 60 * 24);
  const reward = user.amount * 0.1 * (days / 30);

  res.json({ reward });
});

app.listen(3000, () => console.log("Staking rodando"));
[10/4 13:43] Davi Calixto: <h2>Staking</h2>
<input id="wallet" placeholder="Sua wallet">
<input id="amount" placeholder="Quantidade">
<button onclick="stake()">Fazer Stake</button>

<script>
async function stake() {
  const wallet = document.getElementById("wallet").value;
  const amount = document.getElementById("amount").value;

  await fetch("http://localhost:3000/stake", {
    method: "POST",
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify({ wallet, amount })
  });

  alert("Staked!");
}
</script>
[10/4 13:43] Davi Calixto: 🔥 CALXT BURN EXECUTADO

Acabamos de remover tokens do supply.

Tx: [link]

CalixtoSuper Network segue focada em valor real e crescimento sustentável.
[10/4 17:19] Davi Calixto: <!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<title>Calixto Platform</title>

<script src="https://cdn.jsdelivr.net/npm/ethers/dist/ethers.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body {
  margin:0;
  font-family:Arial;
  background:#0b0e11;
  color:white;
}

header {
  background:#111;
  padding:15px;
  display:flex;
  justify-content:space-between;
}

.container {
  display:grid;
  grid-template-columns: repeat(auto-fit,minmax(250px,1fr));
  gap:15px;
  padding:20px;
}

.card {
  background:#161a1e;
  padding:20px;
  border-radius:12px;
}

button {
  background:#f0b90b;
  border:none;
  padding:10px;
  border-radius:6px;
  cursor:pointer;
}

input {
  width:100%;
  padding:10px;
  margin:5px 0;
}

</style>
</head>

<body>

<header>
<div>Calixto Platform</div>
<button onclick="connect()">Conectar</button>
</header>

<div id="wallet" style="padding:10px;">Offline</div>

<div class="container">

<div class="card">
<h3>Saldo</h3>
<p id="balance">0</p>
</div>

<div class="card">
<h3>Reward</h3>
<p id="reward">0</p>
</div>

<div class="card">
<h3>Stake</h3>
<input id="amount">
<button onclick="stake()">Stake</button>
<button onclick="withdraw()">Withdraw</button>
</div>

<div class="card">
<h3>Market</h3>
<p id="price">$--</p>
</div>

<div class="card">
<h3>Stats</h3>
<p id="holders">-- holders</p>
</div>

<div class="card">
<h3>Chart</h3>
<canvas id="chart"></canvas>
</div>

</div>

<script>
let provider, signer, contract, user;

const address = "0x4822e7d596772e58C567c5eD0510bb8f8f318d84";

const abi = [
 "function balanceOf(address) view returns(uint256)",
 "function stake(uint256)",
 "function withdraw()"
];

async function connect(){
  provider = new ethers.providers.Web3Provider(window.ethereum);
  await provider.send("eth_requestAccounts", []);
  signer = provider.getSigner();
  user = await signer.getAddress();

  contract = new ethers.Contract(address, abi, signer);

  document.getElementById("wallet").innerText = user;

  update();
}

async function update(){
  try {
    const bal = await contract.balanceOf(user);
    document.getElementById("balance").innerText =
      ethers.utils.formatUnits(bal,18);
  } catch(e){}
}

// mock market (depois liga API real)
document.getElementById("price").innerText = "$0.01";
document.getElementById("holders").innerText = "120 holders";

// gráfico base
new Chart(document.getElementById('chart'), {
  type:'line',
  data:{
    labels:['1','2','3','4','5'],
    datasets:[{data:[1,2,3,2,5]}]
  }
});

async function stake(){
  const val = document.getElementById("amount").value;
  const tx = await contract.stake(ethers.utils.parseUnits(val,18));
  await tx.wait();
}

async function withdraw(){
  const tx = await contract.withdraw();
  await tx.wait();
}
</script>

</body>
</html>
[10/4 17:22] Davi Calixto: // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address, address, uint256) external returns (bool);
    function transfer(address, uint256) external returns (bool);
}

contract CalixtoStaking {

    IERC20 public token;

    struct User {
        uint256 amount;
        uint256 start;
    }

    mapping(address => User) public users;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function stake(uint256 amount) external {
        require(amount > 0);

        token.transferFrom(msg.sender, address(this), amount);

        users[msg.sender].amount += amount;
        users[msg.sender].start = block.timestamp;
    }

    function reward(address u) public view returns(uint256){
        User memory user = users[u];
        if(user.amount == 0) return 0;

        uint256 time = block.timestamp - user.start;

        return (user.amount * time) / 30 days / 10;
    }

    function withdraw() external {
        User memory user = users[msg.sender];
        require(user.amount > 0);

        uint256 r = reward(msg.sender);
        uint256 total = user.amount + r;

        users[msg.sender].amount = 0;

        token.transfer(msg.sender, total);
    }
}
[10/4 17:24] Davi Calixto: <!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<title>Calixto App</title>

<script src="https://cdn.jsdelivr.net/npm/ethers/dist/ethers.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body{background:#0b0e11;color:white;font-family:Arial;margin:0}
header{background:#111;padding:15px;display:flex;justify-content:space-between}
.container{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:15px;padding:20px}
.card{background:#161a1e;padding:20px;border-radius:12px}
button{background:#f0b90b;border:none;padding:10px;border-radius:6px;cursor:pointer}
input{width:100%;padding:10px;margin:5px 0}
</style>
</head>

<body>

<header>
<div>Calixto App</div>
<button onclick="connect()">Conectar</button>
</header>

<div id="wallet" style="padding:10px;">Offline</div>

<div class="container">

<div class="card"><h3>Saldo</h3><p id="balance">0</p></div>
<div class="card"><h3>Reward</h3><p id="reward">0</p></div>

<div class="card">
<h3>Stake</h3>
<input id="amount">
<button onclick="stake()">Stake</button>
<button onclick="withdraw()">Withdraw</button>
</div>

<div class="card"><h3>Preço</h3><p id="price">$--</p></div>
<div class="card"><h3>Holders</h3><p id="holders">--</p></div>

<div class="card"><canvas id="chart"></canvas></div>

</div>

<script>
let provider, signer, user;

// 🔥 SEU TOKEN
const tokenAddress = "0x4822e7d596772e58C567c5eD0510bb8f8f318d84";

// 🔥 COLOCA O STAKING AQUI DEPOIS DO DEPLOY
const stakingAddress = "COLE_STAKING_AQUI";

const tokenAbi = ["function balanceOf(address) view returns(uint256)"];

const stakingAbi = [
 "function stake(uint256)",
 "function withdraw()",
 "function reward(address) view returns(uint256)"
];

let token, staking;

async function connect(){
  provider = new ethers.providers.Web3Provider(window.ethereum);
  await provider.send("eth_requestAccounts", []);
  signer = provider.getSigner();
  user = await signer.getAddress();

  token = new ethers.Contract(tokenAddress, tokenAbi, signer);
  staking = new ethers.Contract(stakingAddress, stakingAbi, signer);

  document.getElementById("wallet").innerText = user;

  update();
}

async function update(){
  try{
    const bal = await token.balanceOf(user);
    document.getElementById("balance").innerText =
      ethers.utils.formatUnits(bal,18);

    const r = await staking.reward(user);
    document.getElementById("reward").innerText =
      ethers.utils.formatUnits(r,18);
  }catch(e){}
}

// preço real
fetch("https://api.dexscreener.com/latest/dex/tokens/"+tokenAddress)
.then(r=>r.json())
.then(d=>{
  const p = d.pairs[0].priceUsd;
  document.getElementById("price").innerText = "$"+p;
});

// gráfico
new Chart(document.getElementById('chart'),{
 type:'line',
 data:{labels:['1','2','3','4'],datasets:[{data:[1,2,3,4]}]}
});

async function stake(){
  const val = document.getElementById("amount").value;
  const tx = await staking.stake(ethers.utils.parseUnits(val,18));
  await tx.wait();
}

async function withdraw(){
  const tx = await staking.withdraw();
  await tx.wait();
}
</script>

</body>
</html>
[10/4 17:44] Davi Calixto: /app
 ├── login
 ├── dashboard
 │    ├── saldo
 │    ├── staking
 │    ├── histórico
 │    ├── enviar/receber
 │
 ├── admin (controle total)
[10/4 17:44] Davi Calixto: await axios.post("https://api.calixto.network/auth/verify", {
  signature,
  address
});
[10/4 17:45] Davi Calixto: Usuário entra no site
 → conecta wallet
 → assina login
 → entra no dashboard
 → vê saldo
 → faz staking
 → backend registra
 → contrato confirma
[10/4 17:48] Davi Calixto: // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
}

contract CALXTStaking {

    address public token;

    struct Stake {
        uint amount;
        uint startTime;
    }

    mapping(address => Stake) public stakes;

    uint public rewardRate = 10; // 10% ao ano

    constructor(address _token) {
        token = _token;
    }

    function stake(uint amount) external {
        require(amount > 0, "Invalid");

        IERC20(token).transferFrom(msg.sender, address(this), amount);

        stakes[msg.sender].amount += amount;
        stakes[msg.sender].startTime = block.timestamp;
    }

    function calculateReward(address user) public view returns (uint) {
        Stake memory s = stakes[user];
        uint duration = block.timestamp - s.startTime;

        return (s.amount * rewardRate * duration) / (365 days * 100);
    }

    function withdraw() external {
        Stake memory s = stakes[msg.sender];
        uint reward = calculateReward(msg.sender);

        uint total = s.amount + reward;

        stakes[msg.sender].amount = 0;

        IERC20(token).transfer(msg.sender, total);
    }
}
[10/4 20:54] Davi Calixto: [10/4 13:41] Davi Calixto: Site:<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>CalixtoSuper Network</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body { font-family: Arial; background:#0a0a0a; color:white; margin:0; }
    header { padding:40px; text-align:center; }
    h1 { font-size:40px; }
    section { padding:40px; max-width:900px; margin:auto; }
    .btn {
      display:inline-block; padding:12px 20px; margin:10px;
      background:#00ffcc; color:black; text-decoration:none; border-radius:8px;
    }
    ul { line-height: 1.8; }
  </style>
</head>
<body>

<header>
  <h1>CalixtoSuper Network</h1>
  <p>Ecossistema Web3 com utilidade real</p>
  <a class="btn" href="#">Comprar CALXT</a>
  <a class="btn" href="#">Ver Contrato</a>
</header>

<section>
  <h2>Sobre</h2>
  <p>CalixtoSuper é um ecossistema descentralizado focado em pagamentos, staking e infraestrutura Web3.</p>
</section>

<section>
  <h2>Tokenomics</h2>
  <p>Supply: 1.000.000.000 CALXT</p>
  <ul>
    <li>Liquidez: 60%</li>
    <li>Ecossistema: 15%</li>
    <li>Desenvolvimento: 10%</li>
    <li>Marketing: 10%</li>
    <li>Reserva: 5%</li>
  </ul>
</section>

<section>
  <h2>Utilidade</h2>
  <ul>
    <li>Pagamentos</li>
    <li>Staking</li>
    <li>Acesso a serviços</li>
  </ul>
</section>

<section>
  <h2>Roadmap</h2>
  <ul>
    <li>Deploy e PancakeSwap ✔</li>
    <li>Site ✔</li>
    <li>Staking 🔜</li>
    <li>CoinGecko 🔜</li>
  </ul>
</section>

</body>
</html>
[10/4 13:42] Davi Calixto: Stake
import express from "express";

const app = express();
app.use(express.json());

let stakes = [];

app.post("/stake", (req, res) => {
  const { wallet, amount } = req.body;

  stakes.push({
    wallet,
    amount,
    start: Date.now()
  });

  res.json({ success: true });
});

app.get("/reward/:wallet", (req, res) => {
  const user = stakes.find(s => s.wallet === req.params.wallet);

  if (!user) return res.json({ reward: 0 });

  const days = (Date.now() - user.start) / (1000 * 60 * 60 * 24);
  const reward = user.amount * 0.1 * (days / 30);

  res.json({ reward });
});

app.listen(3000, () => console.log("Staking rodando"));
[10/4 13:43] Davi Calixto: <h2>Staking</h2>
<input id="wallet" placeholder="Sua wallet">
<input id="amount" placeholder="Quantidade">
<button onclick="stake()">Fazer Stake</button>

<script>
async function stake() {
  const wallet = document.getElementById("wallet").value;
  const amount = document.getElementById("amount").value;

  await fetch("http://localhost:3000/stake", {
    method: "POST",
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify({ wallet, amount })
  });

  alert("Staked!");
}
</script>
[10/4 13:43] Davi Calixto: 🔥 CALXT BURN EXECUTADO

Acabamos de remover tokens do supply.

Tx: [link]

CalixtoSuper Network segue focada em valor real e crescimento sustentável.
[10/4 14:03] Davi Calixto: <!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<title>CalixtoSuper Dashboard</title>
<script src="https://cdn.jsdelivr.net/npm/ethers/dist/ethers.min.js"></script>

<style>
body {
  background:#0a0a0a;
  color:white;
  font-family:Arial;
  margin:0;
}

header {
  padding:20px;
  background:#111;
  text-align:center;
  font-size:24px;
}

.container {
  display:flex;
  flex-wrap:wrap;
  justify-content:center;
  padding:20px;
}

.card {
  background:#111;
  padding:20px;
  margin:10px;
  width:300px;
  border-radius:15px;
  box-shadow:0 0 20px #00ffcc22;
}

button {
  padding:10px;
  margin:5px;
  background:#00ffcc;
  border:none;
  border-radius:8px;
  cursor:pointer;
}

input {
  padding:10px;
  width:90%;
  margin:5px;
  border-radius:5px;
}
</style>
</head>

<body>

<header>🚀 CalixtoSuper Dashboard</header>

<div style="text-align:center; margin:20px;">
<button onclick="connect()">Conectar Wallet</button>
<p id="wallet">Não conectado</p>
</div>

<div class="container">

<div class="card">
<h3>💰 Saldo</h3>
<p id="balance">0</p>
</div>

<div class="card">
<h3>📈 Reward</h3>
<p id="reward">0</p>
</div>

<div class="card">
<h3>🔒 Stake</h3>
<input id="amount" placeholder="Quantidade">
<button onclick="stake()">Stake</button>
<button onclick="withdraw()">Withdraw</button>
</div>

</div>

<script>
let provider, signer, contract, user;

const address = "0x4822e7d596772e58C567c5eD0510bb8f8f318d84";

// ⚠️ ABI precisa bater com seu contrato REAL
const abi = [
 "function stake(uint256)",
 "function withdraw()",
 "function reward(address) view returns(uint256)",
 "function balanceOf(address) view returns(uint256)"
];

async function connect(){
  provider = new ethers.providers.Web3Provider(window.ethereum);
  await provider.send("eth_requestAccounts", []);
  signer = provider.getSigner();
  user = await signer.getAddress();

  contract = new ethers.Contract(address, abi, signer);

  document.getElementById("wallet").innerText = user;

  update();
}

async function update(){
  try {
    const bal = await contract.balanceOf(user);
    document.getElementById("balance").innerText =
      ethers.utils.formatUnits(bal,18);

    const r = await contract.reward(user);
    document.getElementById("reward").innerText =
      ethers.utils.formatUnits(r,18);
  } catch(e){
    console.log("Contrato pode não suportar funções completas");
  }
}

async function stake(){
  const val = document.getElementById("amount").value;

  const tx = await contract.stake(
    ethers.utils.parseUnits(val,18)
  );

  await tx.wait();
  update();
}

async function withdraw(){
  const tx = await contract.withdraw();
  await tx.wait();
  update();
}
</script>

</body>
</html>
[10/4 14:08] Davi Calixto: <!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<title>CalixtoSuper Dashboard</title>
<script src="https://cdn.jsdelivr.net/npm/ethers/dist/ethers.min.js"></script>

<style>
body {
  background:#0a0a0a;
  color:white;
  font-family:Arial;
  margin:0;
}

header {
  padding:20px;
  background:#111;
  text-align:center;
  font-size:24px;
}

.container {
  display:flex;
  flex-wrap:wrap;
  justify-content:center;
  padding:20px;
}

.card {
  background:#111;
  padding:20px;
  margin:10px;
  width:300px;
  border-radius:15px;
  box-shadow:0 0 20px #00ffcc22;
}

button {
  padding:10px;
  margin:5px;
  background:#00ffcc;
  border:none;
  border-radius:8px;
  cursor:pointer;
}

input {
  padding:10px;
  width:90%;
  margin:5px;
  border-radius:5px;
}
</style>
</head>

<body>

<header>🚀 CalixtoSuper Dashboard</header>

<div style="text-align:center; margin:20px;">
<button onclick="connect()">Conectar Wallet</button>
<p id="wallet">Não conectado</p>
</div>

<div class="container">

<div class="card">
<h3>💰 Saldo</h3>
<p id="balance">0</p>
</div>

<div class="card">
<h3>📈 Reward</h3>
<p id="reward">0</p>
</div>

<div class="card">
<h3>🔒 Stake</h3>
<input id="amount" placeholder="Quantidade">
<button onclick="stake()">Stake</button>
<button onclick="withdraw()">Withdraw</button>
</div>

</div>

<script>
let provider, signer, contract, user;

const address = "0x4822e7d596772e58C567c5eD0510bb8f8f318d84";

// ⚠️ ABI precisa bater com seu contrato REAL
const abi = [
 "function stake(uint256)",
 "function withdraw()",
 "function reward(address) view returns(uint256)",
 "function balanceOf(address) view returns(uint256)"
];

async function connect(){
  provider = new ethers.providers.Web3Provider(window.ethereum);
  await provider.send("eth_requestAccounts", []);
  signer = provider.getSigner();
  user = await signer.getAddress();

  contract = new ethers.Contract(address, abi, signer);

  document.getElementById("wallet").innerText = user;

  update();
}

async function update(){
  try {
    const bal = await contract.balanceOf(user);
    document.getElementById("balance").innerText =
      ethers.utils.formatUnits(bal,18);

    const r = await contract.reward(user);
    document.getElementById("reward").innerText =
      ethers.utils.formatUnits(r,18);
  } catch(e){
    console.lo
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract KaleidoERC20 is ERC20 {
    constructor(string memory name, string memory symbol, uint8 decimals, uint256 initialSupply) ERC20(name, symbol) public {
        _setupDecimals(decimals);
        _mint(_msgSender(), initialSupply * 10**uint(super.decimals()));
    }
}
