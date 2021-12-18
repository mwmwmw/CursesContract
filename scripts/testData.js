function rint() {
    return Math.floor(Math.random() * 1000000)%65535;
  }
  
  function rint8() {
    return Math.floor(Math.random() * 1000000)%256;
  }

function* nftData () {
    var i = 0;
    while (true) {
        yield [`Noise Block ${i}`, `${new Array(Math.ceil(3 + Math.random()*3)).fill(0).map(v=>new Array(Math.ceil(Math.random()*6)).fill('x').join("")).join(" ")}`, [rint(), rint(), rint(), rint8(), rint(), rint8()]];
        i++;
    }
}

module.exports = {
    rint, rint8, nftData
}