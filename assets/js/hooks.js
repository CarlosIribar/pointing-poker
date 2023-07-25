const Hooks = {}
const NAME = "ex-pointer-name";
const ID = "ex-pointer-id";

Hooks.save = {
    mounted() {
        this.handleEvent("saveName", ({ name, id }) => {
            console.log('saveName')
            localStorage.setItem(NAME, name)
            localStorage.setItem(ID, id);
            this.pushEvent("saved-name")
        })
    }
}

Hooks.restore = {
    mounted() {
        const name = localStorage.getItem(NAME)
        const id = localStorage.getItem(ID)
        this.pushEvent("restore", { name, id })
    }
}

export default Hooks
