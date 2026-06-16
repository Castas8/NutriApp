package org.lasalle.rest;

import com.google.gson.Gson;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.sql.SQLException;
import org.lasalle.controller.ControllerPlanNutricional;
import org.lasalle.model.PlanNutricional;

@Path("planes")
public class RestPlanNutricional {

    @GET
    @Path("getByPaciente/{idPaciente}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getByPaciente(@PathParam("idPaciente") int idPaciente) throws SQLException {
        ControllerPlanNutricional cp = new ControllerPlanNutricional();
        Gson gson = new Gson();
        return Response.ok(gson.toJson(cp.getByPaciente(idPaciente))).build();
    }

    @GET
    @Path("getById/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getById(@PathParam("id") int id) throws SQLException {
        ControllerPlanNutricional cp = new ControllerPlanNutricional();
        Gson gson = new Gson();
        PlanNutricional p = cp.getById(id);
        if (p != null) return Response.ok(gson.toJson(p)).build();
        return Response.status(Response.Status.NOT_FOUND)
                .entity("{\"error\":\"Plan no encontrado\"}").build();
    }

    @POST
    @Path("insert")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response insert(PlanNutricional p) throws SQLException {
        ControllerPlanNutricional cp = new ControllerPlanNutricional();
        Gson gson = new Gson();
        p = cp.insert(p);
        return Response.ok(gson.toJson(p)).build();
    }

    @PUT
    @Path("update")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Response update(PlanNutricional p) throws SQLException {
        ControllerPlanNutricional cp = new ControllerPlanNutricional();
        Gson gson = new Gson();
        p = cp.update(p);
        return Response.ok(gson.toJson(p)).build();
    }

    @DELETE
    @Path("delete/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response delete(@PathParam("id") int id) throws SQLException {
        ControllerPlanNutricional cp = new ControllerPlanNutricional();
        boolean ok = cp.delete(id);
        if (ok) return Response.ok("{\"response\":\"Plan eliminado\"}").build();
        return Response.status(Response.Status.NOT_FOUND)
                .entity("{\"error\":\"Plan no encontrado\"}").build();
    }
}