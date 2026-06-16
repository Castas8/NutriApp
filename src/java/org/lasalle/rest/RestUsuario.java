package org.lasalle.rest;

import com.google.gson.Gson;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.sql.SQLException;
import org.lasalle.controller.ControllerUsuario;
import org.lasalle.model.Usuario;

@Path("usuarios")
public class RestUsuario {

    @GET
    @Path("getAll")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAll() throws SQLException {
        ControllerUsuario cu = new ControllerUsuario();
        Gson gson = new Gson();
        return Response.ok(gson.toJson(cu.getAll())).build();
    }

    @GET
    @Path("getById/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getById(@PathParam("id") int id) throws SQLException {
        ControllerUsuario cu = new ControllerUsuario();
        Gson gson = new Gson();
        Usuario u = cu.getById(id);
        if (u != null) {
            return Response.ok(gson.toJson(u)).build();
        }
        return Response.status(Response.Status.NOT_FOUND)
                .entity("{\"error\":\"Usuario no encontrado\"}")
                .build();
    }

    @POST
    @Path("login")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response login(Usuario u) throws SQLException {
        ControllerUsuario cu = new ControllerUsuario();
        Gson gson = new Gson();
        Usuario resultado = cu.login(u.getCorreo(), u.getPassword());
        if (resultado != null) {
            return Response.ok(gson.toJson(resultado)).build();
        }
        return Response.status(Response.Status.UNAUTHORIZED)
                .entity("{\"error\":\"Credenciales incorrectas\"}")
                .build();
    }

    @POST
    @Path("registro")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response registro(Usuario u) throws SQLException {
        ControllerUsuario cu = new ControllerUsuario();
        Gson gson = new Gson();
        u = cu.insert(u);
        return Response.ok(gson.toJson(u)).build();
    }

    @PUT
    @Path("update")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response update(Usuario u) throws SQLException {
        ControllerUsuario cu = new ControllerUsuario();
        Gson gson = new Gson();
        u = cu.update(u);
        return Response.ok(gson.toJson(u)).build();
    }

    @DELETE
    @Path("delete/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response delete(@PathParam("id") int id) throws SQLException {
        ControllerUsuario cu = new ControllerUsuario();
        boolean ok = cu.delete(id);
        if (ok) {
            return Response.ok("{\"response\":\"Usuario eliminado\"}").build();
        }
        return Response.status(Response.Status.NOT_FOUND)
                .entity("{\"error\":\"Usuario no encontrado\"}")
                .build();
    }

    @PUT
    @Path("aprobar/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response aprobar(@PathParam("id") int id) throws SQLException {
        ControllerUsuario cu = new ControllerUsuario();
        cu.aprobar(id);
        return Response.ok("{\"response\":\"Cuenta aprobada\"}").build();
    }

    @PUT
    @Path("rechazar/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response rechazar(@PathParam("id") int id) throws SQLException {
        ControllerUsuario cu = new ControllerUsuario();
        cu.rechazar(id);
        return Response.ok("{\"response\":\"Cuenta rechazada\"}").build();
    }
}