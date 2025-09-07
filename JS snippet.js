async function mostrarCidade(cidadeID) {
    const res = await fetch("/cidades/cidades.json");
    if (!res.ok) {
        console.error("Erro ao carregar o JSON:", res.status);
        return;
    }
    const cidades = await res.json();
    const catalogoSVA = cidades.catalogoSVA;
    const beneficiosPlano = cidades.beneficiosPlano;

    const cidade = cidades[cidadeID];
    if (!cidade) return;

    const nomeFormat = cidade.nome.replace(/\s-\s[A-Z]{2}$/, "");

    document.title = `${nomeFormat} - Cabonnet`;
    
    let favicon = document.querySelector("link[rel~='icon']");
    favicon.href = "../imgs/iconCabonnet.png";

    document.getElementById("titulo-cidade").textContent = cidade.nome;
    document.getElementById("descricao").textContent = cidade.descricao;

    const lista = document.getElementById("lista-planos-home");
    lista.innerHTML = "";

    cidade.planos.forEach(plano => {
    const li = document.createElement("li");
    let iconesBnf = "";
        if(plano.beneficios) {
            iconesBnf = plano.beneficios.map(id => {
                const item = beneficiosPlano[id];
                if (!item) {
                    console.warn("Benefício não encontrado no catálogo:", id);
                    return "";
                }
                return `
                    <span class="sva-icon" data-tooltip="${item.descricao}">
                        <img src="${item.url}" height="20" width="20">
                    </span>`;
            }).join(" ");
        }

    let iconesSVA = "";
        if (plano.svas) {
            iconesSVA = plano.svas.map(id => {
                const item = catalogoSVA[id];
                if (!item) {
                    console.warn("SVA não encontrado no catálogo:", id);
                    return "";
                }
                return `
                    <span class="sva-icon" data-tooltip="<b>${item.titulo}</b></strong>\n${item.descricao}">
                        <img src="${item.url}" height="28">
                    </span>`;
            }).join(" ");
        }
    li.innerHTML = `
        <div class="card-plan">
            <div class="card-header">
                <h3>${plano.tipo}</h3>
                <h4>${plano.velocidade}</h4>
                <div class="icons-plan">
                    ${iconesBnf}
                </div>
                <div class="preco">
                    <span class="valor">${plano.valor}</span><span>/mês</span>
                    <p>${plano.descricao1}</p>
                </div>
                <div class="separador"><br></div>
            </div>
            <div class="card-bottom">
                <p class="sva-title">Este plano inclui:</p>
                <div class="icons-sva">
                    ${iconesSVA}
                </div>
                <div class="desc-plano">
                    ${plano.descricao2.map(texto => `<p>${texto}</p>`).join("")}
                </div>
                <div class="button">
                    <button class="open-letter">Assinar plano</button>
                </div>
            </div>
        </div>
    `;
    lista.appendChild(li);
    });

    // Navegação
    const planPrev = document.querySelector(".plan-prev");
    const planNext = document.querySelector(".plan-next");

    planPrev.onclick = () => {
        if (lista.scrollLeft <= 0) {
            // Se já está no início, vai para o final
            lista.scrollTo({ left: lista.scrollWidth, behavior: "smooth" });
        } else {
            lista.scrollBy({ left: -300, behavior: "smooth" });
        }
    };

    planNext.onclick = () => {
        if (lista.scrollLeft + lista.clientWidth >= lista.scrollWidth) {
            // Se já está no final, volta para o início
            lista.scrollTo({ left: 0, behavior: "smooth" });
        } else {
            lista.scrollBy({ left: 300, behavior: "smooth" });
        }
    };
}