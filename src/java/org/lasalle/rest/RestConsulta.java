package org.lasalle.rest;

import com.google.gson.Gson;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.sql.SQLException;
import org.lasalle.controller.ControllerConsulta;
import org.lasalle.model.Consulta;

@Path("consultas")
public class RestConsulta {
    
    @GET
    @Path("getAll")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAll() throws SQLException {
    ControllerConsulta cc = new ControllerConsulta();
    Gson gson = new Gson();
    return Response.ok(gson.toJson(cc.getAll())).build();
    }

    @GET
    @Path("getByPaciente/{idPaciente}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getByPaciente(@PathParam("idPaciente") int idPaciente) throws SQLException {
        ControllerConsulta cc = new ControllerConsulta();
        Gson gson = new Gson();
        return Response.ok(gson.toJson(cc.getByPaciente(idPaciente))).build();
    }

    @GET
    @Path("getById/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getById(@PathParam("id") int id) throws SQLException {
        ControllerConsulta cc = new ControllerConsulta();
        Gson gson = new Gson();
        Consulta c = cc.getById(id);
        if (c != null) {
            return Response.ok(gson.toJson(c)).build();
        }
        return Response.status(Response.Status.NOT_FOUND)
                .entity("{\"error\":\"Consulta no encontrada\"}")
                .build();
    }

    @POST
    @Path("insert")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response insert(Consulta c) throws SQLException {
        ControllerConsulta cc = new ControllerConsulta();
        Gson gson = new Gson();
        c = cc.insert(c);
        return Response.ok(gson.toJson(c)).build();
    }

    @PUT
    @Path("update")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response update(Consulta c) throws SQLException {
        ControllerConsulta cc = new ControllerConsulta();
        Gson gson = new Gson();
        c = cc.update(c);
        return Response.ok(gson.toJson(c)).build();
    }

    @DELETE
    @Path("delete/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response delete(@PathParam("id") int id) throws SQLException {
        ControllerConsulta cc = new ControllerConsulta();
        boolean ok = cc.delete(id);
        if (ok) {
            return Response.ok("{\"response\":\"Consulta eliminada\"}").build();
        }
        return Response.status(Response.Status.NOT_FOUND)
                .entity("{\"error\":\"Consulta no encontrada\"}")
                .build();
    }
}